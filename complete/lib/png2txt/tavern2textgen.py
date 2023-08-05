import base64
import json
import png
import sys
import glob
import re
import os
import argparse
from PIL import Image

# Define a list to hold the paths to the input PNG files
file_paths = []


def read_metadata(file_path):
    try:
        with open(file_path, "rb") as f:
            r = png.Reader(file=f)
            for chunk in r.chunks():
                if chunk[0] == b"tEXt":
                    key, value = chunk[1].split(b'\x00', 1)
                    if key == b"chara":
                        decoded_value = value.decode("utf-8", errors="replace")
                        return decoded_value
            raise ValueError(f"The specified metadata 'chara' was not found in the PNG file: {file_path}")
    except IOError:
        raise ValueError(f"Failed to open the image file: {file_path}")


def decode_base64(data):
    try:
        decoded_data = base64.b64decode(data)
        # Ignore and remove invalid byte sequences
        return decoded_data.decode("utf-8", errors="ignore")
    except base64.binascii.Error:
        raise ValueError("Failed to decode the base64 data.")


def parse_json(data):
    try:
        json_data = json.loads(data)
        return json_data
    except json.JSONDecodeError:
        raise ValueError("Failed to parse the JSON data.")

def sanitize_file_name(file_name):
    return re.sub(r"[^\w\-_]", "", file_name.replace(" ", "_"))


def resize_image(image_path, output_path):
    with Image.open(image_path) as img:
        # Resize the image proportionally to a width of 390px
        width, height = img.size
        new_width = min(width, 390)
        new_height = int(new_width / width * height)
        img = img.resize((new_width, new_height))
        # Crop the top 390px of the resulting image to get a perfect square
        img.crop((0, 0, 390, min(new_height, 390))).save(output_path)

def create_json(data, file_name):
    """
    Function to create a JSON file for a given data.
    """
    new_data = {
        'char_name': data['name'],
        'char_persona': data['personality'],
        'char_greeting': data['first_mes'],
        'world_scenario': data['scenario'],
        'example_dialogue': data['mes_example'],
    }

    with open(file_name, "w", encoding="utf-8") as f:
        json.dump(new_data, f, ensure_ascii=False, indent=4)

def copy_image(image_path, output_path):
    """
    Function to copy an image without resizing it.
    """
    with Image.open(image_path) as img:
        img.save(output_path)

def main(input_paths, output_directory):
    # Find all the PNG files that match the input paths using glob
    for path in input_paths:
        file_paths.extend(glob.glob(path))

    # Process each PNG file in the list
    for file_path in file_paths:
        try:
            # Read the metadata from the PNG file
            metadata = read_metadata(file_path)
            # Decode the base64-encoded metadata to get the JSON data
            decoded_data = decode_base64(metadata)
            # Parse the JSON data
            json_data = parse_json(decoded_data)
            print(f"File: {file_path}")

            # Create a JSON file for the JSON data
            json_file_name = f"{sanitize_file_name(json_data['name'])}.json"
            json_output_path = os.path.join(output_directory, json_file_name)
            create_json(json_data, json_output_path)
            print(f"JSON file created: {json_output_path}")

            # Copy the PNG file and save it with the same name as the corresponding JSON file
            png_file_name = f"{sanitize_file_name(json_data['name'])}.png"
            png_output_path = os.path.join(output_directory, png_file_name)
            copy_image(file_path, png_output_path)
            print(f"PNG file copied and saved: {png_output_path}")

            print("=" * 40)
        except ValueError as e:
            print(e)
            print("=" * 40)

if __name__ == "__main__":
    # Use argparse to handle command-line arguments
    parser = argparse.ArgumentParser(description="Process PNG files and extract metadata.")
    parser.add_argument("input_paths", nargs="+", help="Input file paths (supports wildcards)")
    parser.add_argument("-o", "--output", default=".", help="Output directory (default: current directory)")
    args = parser.parse_args()

    main(args.input_paths, args.output)