#!/bin/bash

rsync -v -rtzh --checksum --delete ./_site/ myblog:testsitedump