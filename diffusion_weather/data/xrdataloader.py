import json
import numpy as np
import xarray as xr
from torch.utils.data import Dataset
import torchvision.transforms as transforms

class XrDataset(Dataset):
    def __init__(self):
        super().__init__()
        with open("hf_forecasts.json", "r") as f:
            files = json.load(f)
        self.filepaths = [
            "zip:///::https://huggingface.co/datasets/openclimatefix/gfs-reforecast/resolve/main/"
            + f
            for f in files
        ]
        self.data = xr.open_mfdataset(
            self.filepaths, engine="zarr", concat_dim="reftime", combine="nested"
        ).sortby("reftime")

    def __len__(self):
        return len(self.filepaths)

    def __getitem__(self, item):
        start_idx = np.random.randint(0, 14)
        data = self.data.isel(reftime=item, time=slice(start_idx, start_idx + 2))

        start = data.isel(time=0)
        end = data.isel(time=1)
        # Stack the data into a large data cube
        input_data = np.stack(
            [
                start[var].values for var in sorted(start.data_vars)
            ],
            axis=-1,
        )
        input_data = np.nan_to_num(input_data)
        assert not np.isnan(input_data).any()
        output_data = np.stack(
            [
                end[var].values for var in sorted(end.data_vars)
            ],
            axis=-1,
        )
        output_data = np.nan_to_num(output_data)
        assert not np.isnan(output_data).any()
        transform = transforms.Compose([transforms.ToTensor()])
        # return [len(data_vars), latitude, longitude] torch tensor at timestamp=item
        return (
            transform(input_data),
            transform(output_data),
        )
    
#dataset = DataLoader(XrDataset(), batch_size=1, shuffle=True)
