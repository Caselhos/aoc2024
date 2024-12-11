package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:slice"
import "core:time"

day1 :: proc(){
    start := time.tick_now()
    data,err := os.read_entire_file_from_filename("input.txt")
    if !err{
        // error handling
    }
    defer delete(data) // not needed i think since it closes the program anyway

    stringified_data := string(data)
    left_list := [1000]int{}
    right_list := [1000]int{}
    count := 0
    sum := 0 

    for line in strings.split_lines_iterator(&stringified_data){
        s := strings.split(line,"   ")
        ok : bool
        left_list[count], ok = strconv.parse_int(s[0])
        if !ok {
            // error handling
        }
        right_list[count], ok = strconv.parse_int(s[1])
        if !ok {
            // error handling
        }
        count = count + 1
    }
    
    s_left_list: []int = left_list[0:1000]
    s_right_list:[]int = right_list[0:1000]
    slice.sort(s_left_list)
    slice.sort(s_right_list)
    
    for x := 0 ; x < count ; x += 1 {
        test := abs(s_right_list[x] - s_left_list[x])
        sum = sum + test
    }
    fmt.print("PART1: ")
    fmt.println(sum)
    sum = 0 
    for x := 0 ; x < count ; x += 1 {
        times := slice.count(s_right_list,s_left_list[x])
        sum = sum + (times * s_left_list[x])
    }
    fmt.print("PART2: ")
    fmt.println(sum)
    fmt.println(time.tick_since(start))
}