// Create a contract using enum which represents the car ,===>functions to be used ->(ignition on , ignition off , get ignition state).

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract car
{
    enum car{ignition_on, ignition_off, get_ignition_state}
    uint public state;
    car  c1= car.ignition_on;
    car  c2= car.ignition_off;
    function ignition_On() public 
    {
        if(c1==car.ignition_on)
        {
          state=1;
        }
    }
    function ignition_Off() public 
    {
        if(c2==car.ignition_off)
        {
          state=0;
        }
    } 
}
