// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.14;
/*
1. Debe tener un propietario al que se van a realizar los pagos cuando se ocupe la habitación.
2. Debe tener una estructura que defina los dos posibles estados de la habitación de hotel:ocupada o libre.
3. Al desplegarse el contrato, el estado de la habitación será libre.
4. Debe tener una función que permita ocupar y pagar la habitación. El precio será 1 ether
y se transferirá directamente al propietario del contrato. Si la transacción se realiza
correctamente, emitiremos un evento con la información que veamos conveniente.
5. Para poder pagar y ocupar una habitación, esta tiene que estar libre.
*/

contract HotelRoom {

    address payable private owner;

  enum Estados {
      vacante,
      ocupada
  }
     event Occupy (address _ocupante , uint _valor);


   Estados public currentStatus;

  constructor () {
   owner = payable(msg.sender);
   currentStatus = Estados.vacante;

 }

  modifier SoloVacante{
      require(currentStatus == Estados.vacante ,"La habitacion esta ocupada");
      _;
  }



  function OccupyRoom () external  payable SoloVacante {
      require(msg.value >= 1 ether , " No tienes suficiente dinero para alquilar la habitacion");
      currentStatus = Estados.ocupada;
      owner.transfer(msg.value);
      emit Occupy(msg.sender, msg.value);
  }
        
    function Desocupar() external  {
        require(msg.sender == owner);
        require(currentStatus == Estados.ocupada ,"La habitacion esta desocupada");
        currentStatus = Estados.vacante;

    }
}