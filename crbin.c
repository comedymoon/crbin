/*
 * Clearly Random Binary (crbin)
 * Copyright (C) 2025  comedymoon
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * WARNING:
 *   DO NOT RUN CRBIN AS ROOT.
 *   DO NOT RUN CRBIN WITH SUDO.
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <unistd.h>
#include <sys/stat.h>
#include <time.h>

typedef struct {
    char **items;
    size_t count;
    size_t cap;
} list_t;

static void list_init(list_t *list) {
    list->cap = 16;
    list->count = 0;
    list->items = malloc(list->cap * sizeof(char *));
}

static void list_add(list_t *list, const char *s) {
    if (list->count == list->cap) {
        list->cap *= 2;
        list->items = realloc(list->items, list->cap * sizeof(char *));
    }
    list->items[list->count++] = strdup(s);
}

static void list_free(list_t *list) {
    for (size_t i = 0; i < list->count; i++)
        free(list->items[i]);
    free(list->items);
}

static void scan_directory(const char *dirpath, list_t *bins, int recurse) {
    DIR *d = opendir(dirpath);
    if (!d) return;

    struct dirent *ent;
    while ((ent = readdir(d)) != NULL) {
        if (ent->d_name[0] == '.' &&
           (ent->d_name[1] == '\0' ||
           (ent->d_name[1] == '.' && ent->d_name[2] == '\0')))
            continue;

        char fullpath[4096];
        snprintf(fullpath, sizeof(fullpath), "%s/%s", dirpath, ent->d_name);

        struct stat st;
        if (stat(fullpath, &st) != 0) continue;

        if (S_ISREG(st.st_mode)) {
            if (access(fullpath, X_OK) == 0)
                list_add(bins, fullpath);
        } else if (recurse && S_ISDIR(st.st_mode)) {
            scan_directory(fullpath, bins, recurse);
        }
    }

    closedir(d);
}

int main(int argc, char **argv) {
    list_t bins;
    list_init(&bins);

    int recurse = 0;
    const char *rec = getenv("RECURSE");
    if (rec && strcmp(rec, "1") == 0)
        recurse = 1;

    const char *envdirs = getenv("BINDIRECTORIES");

    if (envdirs && envdirs[0]) {
        char *copy = strdup(envdirs);
        char *dir = strtok(copy, ",");
        while (dir) {
            scan_directory(dir, &bins, recurse);
            dir = strtok(NULL, ",");
        }
        free(copy);
    } else {
        const char *defaults[] = {
            "/bin",
            "/usr/bin",
            "/usr/local/bin",
            "/sbin",
            "/usr/sbin",
            "/usr/local/sbin",
            NULL
        };
        for (int i = 0; defaults[i]; i++)
            scan_directory(defaults[i], &bins, recurse);
    }

    if (bins.count == 0)
        _exit(1);

    srand(time(NULL) ^ getpid());
    const char *cmd = bins.items[rand() % bins.count];

    char **exec_args = malloc((argc + 1) * sizeof(char *));
    exec_args[0] = (char *)cmd;
    for (int i = 1; i < argc; i++)
        exec_args[i] = argv[i];
    exec_args[argc] = NULL;

    execvp(cmd, exec_args);
    _exit(1);
}
