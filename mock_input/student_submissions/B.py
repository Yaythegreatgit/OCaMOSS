def get_max_element(nums):
    out = nums[0]
    for num in nums:
        out = max(out, num)
    return out

if __name__ == '__main__':
    x = get_max_element([5,2,3,1])
    print(f"Max element is: {x}")
