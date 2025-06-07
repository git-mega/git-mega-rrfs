#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <stdbool.h>
#include <ctype.h>
#include <unistd.h>
#include <libgen.h>

#define MAX_LINE 512
#define MAX_EXCLUDES 512

// Helper: get file size
long getFileSize(const char *filename) {
    struct stat pathStat;
    return stat(filename, &pathStat) == 0 ? pathStat.st_size : -1;
}

// Read threshold and excludes from .mega.config
long readConfig(const char *configPath, char excludes[][MAX_LINE], int *excludeCount) {
    FILE *fp = fopen(configPath, "r");
    if (!fp) return 1000;

    char line[MAX_LINE];
    long threshKB = 1000;
    *excludeCount = 0;

    while (fgets(line, MAX_LINE, fp)) {
        if (line[0] == '#') continue;
        if (strncmp(line, "file_size>", 10) == 0) {
            sscanf(line + 10, "%ldkb", &threshKB);
        } else if (line[0] == '!') {
            if (*excludeCount < MAX_EXCLUDES) {
                strncpy(excludes[*excludeCount], line + 1, MAX_LINE);
                excludes[*excludeCount][strcspn(excludes[*excludeCount], "\r\n")] = 0;
                (*excludeCount)++;
            }
        }
    }

    fclose(fp);
    return threshKB;
}

// Check if file is excluded by name
bool isExcluded(const char *filename, char excludes[][MAX_LINE], int excludeCount) {
    for (int i = 0; i < excludeCount; ++i) {
        if (strcmp(filename, excludes[i]) == 0) return true;
    }
    return false;
}

// check if a text file is a Mega file
bool isMegaFile(const char *path, const char *configPath) {
    // Read config
    char excludes[MAX_EXCLUDES][MAX_LINE];
    int excludeCount;
    long threshKB = readConfig(configPath, excludes, &excludeCount);
    long threshBytes = threshKB * 1024;

    // Exclusion by filename
    if (isExcluded(path, excludes, excludeCount)) return false;

    long filesize = getFileSize(path);
    return filesize > threshBytes;
}

int main(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: %s <file> <.mega.conf>\n", argv[0]);
        return 1;
    }

    if (isMegaFile(argv[1], argv[2])) {
        printf("YES\n");
    } else {
        printf("NO\n");
    }

    return 0;
}
