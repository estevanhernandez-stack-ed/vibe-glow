#!/usr/bin/env python3
"""Crop a capture and walk pixel values. Eyeballing a downscaled preview
lies (filled buttons read as outlined, subtle halos vanish); pixels do not.
Requires Pillow: pip install pillow. Optional dependency of the adapter."""
import argparse

from PIL import Image

parser = argparse.ArgumentParser(description="crop + walk pixel values")
parser.add_argument("image")
parser.add_argument("--crop", help="x,y,w,h region before walking")
parser.add_argument("--walk", choices=["horizontal", "vertical"], default="horizontal",
                    help="walk the middle row (horizontal) or column (vertical)")
parser.add_argument("--step", type=int, default=1, help="sample every N pixels")
parser.add_argument("--out", help="also save the cropped region here")
args = parser.parse_args()

im = Image.open(args.image).convert("RGB")
if args.crop:
    x, y, w, h = (int(v) for v in args.crop.split(","))
    im = im.crop((x, y, x + w, y + h))
if args.out:
    im.save(args.out)

width, height = im.size
if args.walk == "horizontal":
    yy = height // 2
    for xx in range(0, width, args.step):
        print(xx, yy, im.getpixel((xx, yy)))
else:
    xx = width // 2
    for yy in range(0, height, args.step):
        print(xx, yy, im.getpixel((xx, yy)))
