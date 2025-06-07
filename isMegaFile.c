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
#define PATH_MAX 512

// Helper: get Git top-level directory
bool getGitRoot(char *output, size_t len) {
    FILE *fp = popen("git rev-parse --show-toplevel 2>/dev/null", "r");
    if (!fp) return false;
    if (!fgets(output, len, fp)) {
        pclose(fp);
        return false;
    }
    // Remove newline
    output[strcspn(output, "\r\n")] = 0;
    pclose(fp);
    return true;
}

// Helper: check if path is a directory
bool isDirectory(const char *path) {
    struct stat pathStat;
    return stat(path, &pathStat) == 0 && S_ISDIR(pathStat.st_mode);
}

// Helper: check if path is a symlink
bool isSymlink(const char *path) {
    struct stat pathStat;
    return lstat(path, &pathStat) == 0 && S_ISLNK(pathStat.st_mode);
}

// Helper: get file size
long getFileSize(const char *filename) {
    struct stat pathStat;
    return stat(filename, &pathStat) == 0 ? pathStat.st_size : -1;
}

// Helper: check if file is binary
bool isBinaryFile(const char *filename) {
    FILE *fp = fopen(filename, "rb");
    if (!fp) return true;

    int c, ascii = 0, nonascii = 0;
    for (int i = 0; i < 1024 && (c = fgetc(fp)) != EOF; i++) {
        if (iscntrl(c) && !isspace(c)) nonascii++;
        else ascii++;
    }
    fclose(fp);
    return nonascii > ascii;
}

// Read threshold and excludes from .mega.config
long readConfig(const char *configPath, char excludes[][MAX_LINE], int *excludeCount) {
    FILE *fp = fopen(configPath, "r");
    if (!fp) return 1000;

    char line[MAX_LINE];
    long thresholdKB = 1000;
    *excludeCount = 0;

    while (fgets(line, MAX_LINE, fp)) {
        if (line[0] == '#') continue;
        if (strncmp(line, "file_size>", 10) == 0) {
            sscanf(line + 10, "%ldkb", &thresholdKB);
        } else if (line[0] == '!') {
            if (*excludeCount < MAX_EXCLUDES) {
                strncpy(excludes[*excludeCount], line + 1, MAX_LINE);
                excludes[*excludeCount][strcspn(excludes[*excludeCount], "\r\n")] = 0;
                (*excludeCount)++;
            }
        }
    }

    fclose(fp);
    return thresholdKB;
}

// Check if file is excluded by name
bool isExcluded(const char *filename, char excludes[][MAX_LINE], int excludeCount) {
    char *base = basename((char *)filename);
    for (int i = 0; i < excludeCount; ++i) {
        if (strcmp(base, excludes[i]) == 0) return true;
    }
    return false;
}

// Main API
bool isMegaFile(const char *path) {
    if (isDirectory(path) || isSymlink(path)) return false;

    // Find .mega.config from Git root
    char gitRoot[PATH_MAX];
    if (!getGitRoot(gitRoot, sizeof(gitRoot))) return false;

    char configPath[PATH_MAX];
    snprintf(configPath, sizeof(configPath), "%s/.mega.config", gitRoot);

    // Read config
    char excludes[MAX_EXCLUDES][MAX_LINE];
    int excludeCount;
    long thresholdKB = readConfig(configPath, excludes, &excludeCount);
    long thresholdBytes = thresholdKB * 1024;

    // Exclusion by filename
    if (isExcluded(path, excludes, excludeCount)) return false;

    // Binary check
    if (isBinaryFile(path)) return true;

    // File size check
    long filesize = getFileSize(path);
    return filesize > thresholdBytes;
}

