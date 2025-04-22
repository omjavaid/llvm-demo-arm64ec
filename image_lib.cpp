#include "image_lib.h"
#include <stdlib.h>
#include <memory.h>

extern "C" {
    IMAGE_API ImageData* create_image(int width, int height) {
        ImageData* img = (ImageData*)malloc(sizeof(ImageData));
        img->width = width;
        img->height = height;
        img->channels = 3;  // RGB
        img->data = (unsigned char*)malloc(width * height * 3);
        return img;
    }

    IMAGE_API void free_image(ImageData* img) {
        if (img) {
            free(img->data);
            free(img);
        }
    }

    IMAGE_API void fill_gradient(ImageData* img) {
        for (int y = 0; y < img->height; y++) {
            for (int x = 0; x < img->width; x++) {
                int idx = (y * img->width + x) * 3;
                // Create a simple RGB gradient
                img->data[idx] = (unsigned char)((float)x / img->width * 255);     // R
                img->data[idx + 1] = (unsigned char)((float)y / img->height * 255); // G
                img->data[idx + 2] = 128;                                          // B
            }
        }
    }

    IMAGE_API void adjust_brightness(ImageData* img, float factor) {
        for (int i = 0; i < img->width * img->height * img->channels; i++) {
            float pixel = img->data[i] * factor;
            img->data[i] = (unsigned char)(pixel > 255 ? 255 : pixel);
        }
    }

    IMAGE_API void convert_to_grayscale(ImageData* img) {
        for (int i = 0; i < img->width * img->height; i++) {
            int idx = i * 3;
            // Standard grayscale conversion weights
            unsigned char gray = (unsigned char)(
                img->data[idx] * 0.299f +      // R
                img->data[idx + 1] * 0.587f +  // G
                img->data[idx + 2] * 0.114f    // B
            );
            img->data[idx] = gray;
            img->data[idx + 1] = gray;
            img->data[idx + 2] = gray;
        }
    }
} 