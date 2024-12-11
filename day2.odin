package main

import "core:fmt"
import "core:strings"
import "core:time"
import "core:slice"
import "core:strconv"


is_sorted_custom :: proc(slice: $T/[]$E) -> (bool,bool) {
    asc, des := true,true
    for i in 0..<len(slice) - 1 {
        if slice[i] > slice[i+1] && asc == true{
            asc = false
        }
        if slice[i] < slice[i+1] && des == true{
            des = false
        }
    }
    return asc,des
}

array_strings_to_array_ints :: proc(array: ^[]string) -> []int {
    buffer := make([]int, len(array),context.temp_allocator)
    pos := 0
    for x in array{
        buffer[pos] = strconv.atoi(x)
        pos +=1
    }
    return buffer   
}

check_unsafe :: proc(array: []int, safe_c2 : ^int){
    buffer := make([]int, len(array)-1,context.temp_allocator)
    for x in 0..<len(array){
        pos := 0
        for i in 0..<len(array){
            if x != i{
                buffer[pos] = array[i]
                pos +=1
            }
        }
        asc,des := is_sorted_custom(buffer)
        if (asc || des){
            if check_ranges_unsafe(buffer,safe_c2){
                return
            }
        }
    }
}
check_ranges_unsafe :: proc(array:[]int, safe_c2 : ^int) -> bool{
    for x in 0..<len(array) - 1{
        diff := abs(array[x] - array[x+1])
        if diff > 3 || diff < 1{  
            break  
        }
        if x + 1 == len(array) - 1{
            safe_c2^ += 1
            return true
        }
        
    }
    return false  
}
check_ranges_part2 :: proc(array:[]int, safe_c2 : ^int){
    test : [dynamic]int
    test2 : [dynamic]int
    for x in 0..<len(array) - 1{  
        diff := abs(array[x] - array[x+1])
        if diff > 3 || diff < 1{
            test = slice.clone_to_dynamic(array)
            test2 = slice.clone_to_dynamic(array)
            ordered_remove(&test,x+1)
            if check_ranges_unsafe(test[:],safe_c2){
                break
            }
            else {
                ordered_remove(&test2,x)
                if check_ranges_unsafe(test2[:],safe_c2){
                    break
                }
            }
            break
        }
        if x + 1 == len(array) - 1{
            safe_c2^ += 1
        }
        
    }  
}
check_ranges_part1 :: proc(array:[]int, safe_c : ^int){
    for x in 0..<len(array) - 1{
        diff := abs(array[x] - array[x+1])
        if diff > 3 || diff < 1{
            break
        }
        if x + 1 == len(array) - 1{
            safe_c^ += 1
        }     
    }
}

day2 :: proc(){
    data : string = #load("input2.txt",string) or_else "Failed loading the file"
    start := time.now()
    data_array := strings.split(data,"\n")
    safe_count : int = 0
    safe_count2 : int = 0
    for data_line in data_array{
        data_line_array := strings.split(data_line," ")
        data_line_ints := array_strings_to_array_ints(&data_line_array)
        asc,des := is_sorted_custom(data_line_ints[:])
        if (!asc && !des){
            check_unsafe(data_line_ints[:],&safe_count2)
        }
        else{
            check_ranges_part1(data_line_ints[:],&safe_count)
            check_ranges_part2(data_line_ints[:],&safe_count2)
        }
    }fmt.println(time.duration_milliseconds(time.since(start)))
    fmt.println("PART1 - ",safe_count)
    fmt.println("PART2 - ",safe_count2)
    
}


