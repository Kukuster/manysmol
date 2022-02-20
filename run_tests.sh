test_dir_1="test1"
test_tar_1="test1.tar"
hashsum_table_1="test1_md5sums.tsv"

test_dir_2="test2"
test_tar_2="test2.tar"
hashsum_table_2="test2_md5sums.tsv"

# prints 
reprintf(){
    printf "\r\033[K${1}"
}


read_bare_files(){
    local test_dir="$1"
    local hashsum_table="$2"
    
    local hashsum_table_contents=$(cat "$hashsum_table")

    local hash_and_file=()
    local hash=""
    local file=""
    local testhash=""

    time {
        while IFS="" read -r line || [ -n "$line" ];
        do
            hash_and_file=( $line )
            hash=${hash_and_file[0]}
            file=${hash_and_file[1]}

            reprintf "at file: $file"

            testhash="$(md5sum "$test_dir/$file" | awk '{print $1}')"
            if [[ "$hash" != "$testhash" ]]; then
                printf "\nERROR: test failed at file $file: newly calculated hashsum doesn't match\n"
                printf "old hash: $hash\n"
                printf "new hash: $testhash\n"
                break
            fi

        done <<< $hashsum_table_contents
    }

}


read_tard_files(){
    local test_tar="$1"
    local hashsum_table="$2"

    local hashsum_table_contents=$(cat "$hashsum_table")

    local hash_and_file=()
    local hash=""
    local file=""
    local testhash=""
    
    time {
        hashes="$(
            cut -d$'\t' -f1 "$hashsum_table"
        )"
        testhashes="$(
            tar -xf "$test_tar" --to-command 'echo $(md5sum | cut -d " " -f1)'
        )"

        if [[ "$hash" != "$testhash" ]]; then
            printf "\nERROR: test failed newly calculated hashsums don't match\n"
        fi

    }
}


echo "===== TEST1 ====="
echo "1. reading bare files"
read_bare_files "$test_dir_1" "$hashsum_table_1"
echo "2. reading tard files"
read_tard_files "$test_tar_1" "$hashsum_table_1"


echo "===== TEST2 ====="
echo "1. reading bare files"
read_bare_files "$test_dir_2" "$hashsum_table_2"
echo "2. reading tard files"
read_tard_files "$test_tar_2" "$hashsum_table_2"

