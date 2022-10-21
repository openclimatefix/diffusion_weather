# Diffusion Weather



## Installation

This library can be installed through

```bash
pip install diffusion-weather
```

## Example Usage


## Pretrained Weights
Coming soon! We plan to train a model on GFS 0.25 degree operational forecasts, as well as MetOffice NWP forecasts.
We also plan trying out adaptive meshes, and predicting future satellite imagery as well.

## Training Data
Training data will be available through HuggingFace Datasets for the GFS forecasts. The initial set of data is available for [GFSv16 forecasts, raw observations, and FNL Analysis files from 2016 to 2022](https://huggingface.co/datasets/openclimatefix/gfs-reforecast), and for [ERA5 Reanlaysis](https://huggingface.co/datasets/openclimatefix/era5). MetOffice NWP forecasts we cannot
redistribute, but can be accessed through [CEDA](https://data.ceda.ac.uk/).
