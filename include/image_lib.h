#pragma once

#ifdef IMAGE_LIB_EXPORTS
#define IMAGE_API __declspec(dllexport)
#else
#define IMAGE_API __declspec(dllimport)
#endif

extern "C" {
    // Simple structure to hold image data
    struct ImageData {
        unsigned char* data;  // RGB data
        int width;
        int height;
        int channels;        // 3 for RGB
    };

    // Basic image operations
    IMAGE_API ImageData* create_image(int width, int height);
    IMAGE_API void free_image(ImageData* img);
    IMAGE_API void fill_gradient(ImageData* img);
    IMAGE_API void adjust_brightness(ImageData* img, float factor);
    IMAGE_API void convert_to_grayscale(ImageData* img);
} 