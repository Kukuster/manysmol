# calculates md5 hashes of all (non-hidden) files in the test dirs and saves table to tsv files

test_dir_1="test1"
result_table_1="test1_md5sums.tsv"

test_dir_2="test2"
result_table_2="test2_md5sums.tsv"


calc_hashes_and_save_table(){
    test_dir="$1"
    result_table="$2"

    cd "$test_dir"
    time {
        md5sum * | stdbuf -oL awk '{print $1"\t"$2}' | tee "$result_table" ;
    }
    cd -

}


calc_hashes_and_save_table "$test_dir_1" "$result_table_1"
calc_hashes_and_save_table "$test_dir_2" "$result_table_2"

