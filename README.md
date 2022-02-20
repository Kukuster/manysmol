# manysmol

Tests for comparing speed of reading a large number of tiny files from a s3fs on an s3:
 - speed of reading files directly from the file system (separate files)
 - speed of reading the same files from within a tar

## methods
The test is conducted by running `bash run_tests.sh`, and the results are given by the measures of time taken in the output via bash's `time` command.

The time taken by awaiting file system request for disk access is assumed to be the difference between `real` measure and a sum of `user` and `sys`. It's ok to take a sum of `user` and `sys` assuming they don't overlap, because the process of this test is sequential and is excecuted only on 1 core at a time.

The test consists of:
 - taking `time` measure of reading files directly from the file system
 - taking `time` measure of reading the same list of files from the tar archive

By "reading" the following process is meant:
    - calculating md5 hash of the file contents
    - comparing this md5 hash to the previously calculated and verifying the exact match (otherwise test fails with error)


## Results

### 2022-02-19
see `results.2022-02-19.txt`
