#include "image_lib.h"
#include <stdio.h>

// Simple PPM image writer
void save_ppm(const char* filename, ImageData* img) {
    FILE* fp = fopen(filename, "wb");
    if (!fp) return;

    // Write PPM header
    fprintf(fp, "P6\n%d %d\n255\n", img->width, img->height);
    
    // Write image data
    fwrite(img->data, 1, img->width * img->height * 3, fp);
    
    fclose(fp);
}

int main() {
    printf("Creating test images...\n");

    // Create a 256x256 image
    ImageData* img = create_image(256, 256);
    
    // Fill with gradient
    fill_gradient(img);
    save_ppm("gradient.ppm", img);
    printf("Saved gradient.ppm\n");

    // Adjust brightness
    adjust_brightness(img, 1.5f);
    save_ppm("bright.ppm", img);
    printf("Saved bright.ppm\n");

    // Convert to grayscale
    convert_to_grayscale(img);
    save_ppm("gray.ppm", img);
    printf("Saved gray.ppm\n");

    // Cleanup
    free_image(img);
    return 0;
} 