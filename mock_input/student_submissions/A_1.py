def get_max_element(nums):
    v = nums[0]
    for num in nums:
        if num > v:
            v = num
    return v

if __name__ == '__main__':
    x = get_max_element([5,2,3,1])
    print(f"Max element is: {x}")
