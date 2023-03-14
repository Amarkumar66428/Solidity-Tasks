// created a dynamic array where we are inserting element dynamically,deleting an element using its index,deleting an element using its value

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract DynaArray
{
    uint[] public arr;
    uint index;

    function pushElement(uint item) public
    {
        arr.push(item);
    }
    function arr_len() public view returns(uint)
    {
        return arr.length;
    }
     function deleteElement(uint element) public {
        for (uint i = 0; i < arr.length; i++) {
            if (arr[i] == element) {
                deleteAtIndex(i);
                break;
            }
        }
    }
    
    function deleteAtIndex(uint index1) public {
        require(index1 < arr.length, "Index out of bounds");
        
        for (uint i = index1; i < arr.length - 1; i++) {
            arr[i] = arr[i+1];
        }
        arr.pop();
    }
}

