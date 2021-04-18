pragma solidity ^0.5.0;

contract Owned {
    
    // payable vai permitir que enviemos ether para este endereco
    address payable owner;
    
    constructor() public {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner, "Somente o dono do contrato pode executar essa função");
        _; 
        // temos que colocar o "_;" pois qualquer funcao que tirer o modificador onlyOwner vai 
        // passar primeiro pelo require e depois vai executar o corpo da funcao em questao
    }
}

contract Mortal is Owned {
    // Somente o dono do contrato podera chamar a autodestruicao
    function destroy() public onlyOwner {
        selfdestruct(owner);
    }
}
