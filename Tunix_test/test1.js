const prompt = require("prompt-sync")();
const arr1 = [];                                         // declering dynamic array 1
const arr2 = [];                                         // declering dynamic array 2
const Array =[];                                         // declering dynamic for output array 3
                                       
let a = parseInt(prompt("Enter Length of array1: "));    // taking lenght for first array
let b = parseInt(prompt("Enter Length of array2: "));    // taking lenght for second array 

for(let i = 0; i<a;i++){                                 // itrating to get element at each index for 1st array
    let value = parseInt(prompt("Enter elements for 1st array: ")); 
    arr1.push(value);                                    // assigning element to dynamic arr1 
}
for(let i = 0; i<b;i++){                                 // itrating to get element at each index for 2nd array
    let value = parseInt(prompt("Enter elements for 2nd array: "));
    arr2.push(value);                                    // assigning element to dynamic arr2
}

function arrayIntersection(arr1 ,arr2)
{    
    for(let i = 0 ; i<arr1.length;i++){                  // iterting at each element till lenght of arr1
        for(let j = 0 ; j<arr2.length;j++){              // iterting at each element till lenght of arr2
            if(arr1[i] == arr2[j]){                      // Comparing elements of arr1 and arr2 for each iteration 
                Array.push(arr1[i]);                     // if any element in both arr1 and arr2 matches it will push to Array
            }
        }
    }
    console.log(Array);                                  // it will give output Array
}
arrayIntersection(arr1,arr2);                            // calling function arrayIntersaction