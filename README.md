# PixFlix: Frame by Frame Mac-nic!

Welcome to PixFlix, the fun and easy way to turn your images into a video on your Mac! Whether you're creating a photo montage or a quick slideshow, PixFlix has got you covered.

## Project Overview

PixFlix is an OS X application that allows you to compose videos from a series of images. With PixFlix, you can:

- **Create a Video**: Combine multiple images to create a video.
- **Rearrange Images**: Easily reorder your images to get them in the perfect sequence.
- **Resize Images**: All images will be automatically resized to match the final video size.
- **Set Final Duration**: Define the total duration of your video, with each image's display time calculated accordingly.

### Important Notes:
- Aspect ratios of images are **not** respected; if an image's ratio differs from the final video's ratio, it will be distorted.
- The final duration of the video determines how long each image will be shown based on the number of images.

## Getting Started

### Prerequisites

Before you can compile and run PixFlix, make sure you have the following installed on your Mac:

- **Xcode**: Download from the [Mac App Store](https://apps.apple.com/us/app/xcode/id497799835?mt=12).
- **Homebrew** (optional): For installing dependencies (if needed). Get it [here](https://brew.sh/).

### Downloading PixFlix

Clone the repository to your local machine using the following command:

```bash
git clone https://github.com/yourusername/pix-flix.git
```

### Compiling PixFlix

Once you have cloned the repository, navigate to the project directory and open the Xcode project:

```bash
cd pix-flix
open pix-flix.xcodeproj
```

In Xcode:

1. Choose your target device (usually "My Mac").
2. Press `Cmd + R` to build and run the application.

### Running PixFlix

After successfully building the project, PixFlix will open, and you can start adding your images to create your video:

1. Create projectw
2. Drag and drop images into the PixFlix window.
3. Rearrange the images as needed.
4. Set your desired video size and final duration.
5. Click "ENCODE" and let PixFlix do its magic!

The final video will be saved to your chosen output directory.

## Contributing

This project is a learning experience. Although contributions are closed, feel free to use and iterate on it. Please add a mention and a link if you do so.

### License

PixFlix is open-source software licensed under the [MIT License](LICENSE).

## Contact

For any questions or suggestions, please open an issue on GitHub.

Happy video making with PixFlix! 🎬
