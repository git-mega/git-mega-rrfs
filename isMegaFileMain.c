#include <stdio.h>
#include <stdbool.h>

bool isMegaFile(const char *path);

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <file_or_path>\n", argv[0]);
        return 1;
    }

    if (isMegaFile(argv[1])) {
        printf("This is a Mega file.\n");
    } else {
        printf("This is NOT a Mega file.\n");
    }

    return 0;
}

