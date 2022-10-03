def get_max_element(nums):
    cur = nums[0]
    for num in nums:
        if num > cur:
            cur = num
    return cur

if __name__ == '__main__':
    x = get_max_element([5,2,3,1])
    print(f"Max element is: {x}")
