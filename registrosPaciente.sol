// Nome: Wesley Gurgel Marcelino de Oliveira
// Nome: Igor Silva Bento
// Conta do contrato:

pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2; //usado para tentar retornar a struct Paciente

import "./Owned.sol";

contract RegistroPaciente is Mortal {
 
    // Eventos
    event pacienteCadastrado(string nome, uint CPF);
    event medicamentoCadastrado(uint id, string nomeMedicamento, string dataInicioTratamento, string dataFimTratamento);
    
    // Características de um paciente, dados obrigatórios para o cadastro
    struct Paciente {
        //uint ID;
        string nome;
        uint CPF; //todo: quero colocar o CPF como ID
        string dataNascimento;
        string sexo; // não tem char, por enquanto fica assim
        
    }
    
    // Características do medicamento, dados obrigatórios para o cadastro
    struct Medicamento {
        string nomeMedicoReceitou;
        uint codigoMedicamento;
        string nomeMedicamento;
        string dataInicioTratamento;
        string dataFimTratamento;
    }
    
    // Cada ID (paciente) possui um array de registros de medicamentos
    mapping (uint => Medicamento[]) registroMedicamentos;
    mapping (uint => uint) chaveCpfId;
    // CPF => index
    
    // Array com todos os pacientes cadastrados
    Paciente[] public registros;
    
    /*
    *FUNCOES DE CADASTRO
    */
    //Cadastrar Paciente
    function cadastrarPaciente(string memory _nome, uint _CPF, string memory _dataNascimento, string memory _sexo) public returns (bool) {
        //uint id = registros.length + 1;
        registros.push(Paciente(_nome,_CPF,_dataNascimento, _sexo));
        chaveCpfId[_CPF] = registros.length;
        emit pacienteCadastrado(_nome, _CPF);
        return true;
    }
    
    //Cadastrar remedios receitados ao Paciente
    function cadastrarRemedio(uint CPF, string memory _nomeMedicoReceitou, uint _codigoMedicamento, 
    string memory _nomeMedicamento, string memory _dataInicioTratamento, string memory _dataFimTratamento) public {
        require(chaveCpfId[CPF] != 0, "CPF buscado não existe!");
        registroMedicamentos[CPF].push(Medicamento(_nomeMedicoReceitou, _codigoMedicamento, _nomeMedicamento, _dataInicioTratamento, _dataFimTratamento));
        emit medicamentoCadastrado(CPF, _nomeMedicamento, _dataInicioTratamento, _dataFimTratamento);
        
    }
    
    /*
    *FUNCOES DE EDITACAO
    */
    // Editar registro do paciente, apenas nao eh permitido edicao do CPF
    // Caso o CPF tenha sido inserido errado, delete o registro e realize o cadastro novamente
    function editarPaciente(uint _CPF, string memory _nome, string memory _dataNascimento, string memory _sexo) public returns (bool) {
        require(chaveCpfId[_CPF] != 0, "CPF buscado não existe!");
        uint index = chaveCpfId[_CPF]-1;
        registros[index].nome = _nome;
        registros[index].dataNascimento = _dataNascimento;
        registros[index].sexo = _sexo;
        return true;
    }
    
    // Editar Medicamento especifico, precisa-se do codigo do medicamento e CPF para encontrar o paciente
    // Eh realizada a edicao de todos os parametros exceto o codigo do medicamento, em caso de erro no codigo do medicmento recomenda-se
    // deletar o cadastro do medicamento e realizar o cadastro novamente
    function editarMedicamento(uint CPF, uint _codigoMedicamento, string memory _nomeMedicoReceitou, 
    string memory _nomeMedicamento, string memory _dataInicioTratamento, string memory _dataFimTratamento) public returns (bool) {
        require(chaveCpfId[CPF] != 0, "CPF buscado não existe!");
        uint index = getMedicamento(CPF, _codigoMedicamento);
        registroMedicamentos[CPF][index].nomeMedicoReceitou = _nomeMedicoReceitou;
        registroMedicamentos[CPF][index].nomeMedicamento = _nomeMedicamento;
        registroMedicamentos[CPF][index].dataInicioTratamento = _dataInicioTratamento;
        registroMedicamentos[CPF][index].dataFimTratamento = _dataFimTratamento;
        
        return true;
    }
    
    
    //todo Usar CPF como ID
    
    
    /*
    *FUNCOES DE EXCLUSAO
    */
    //Excluir paciente dos registros
    function deletarPaciente(uint CPF) public returns (bool) {
        require(chaveCpfId[CPF] != 0, "CPF buscado não existe!");
        uint index = chaveCpfId[CPF]-1;
        removeNoOrder(index);
        delete chaveCpfId[CPF]; 
        delete registroMedicamentos[CPF];
        //saber se o paciente existe
        //deletar do registros
        //atualizar ID os outros pacientes?
        // Ou trocar ID por CPF como identificador unico
        return true;
        
    }
    // Excluir um medicamento, atraves do CPF do paciente e codigo do medicamento cadastrado
    function deletarMedicamentoPaciente(uint CPF, uint _codigoMedicamento) public returns (bool){
        require(chaveCpfId[CPF] != 0, "CPF buscado não existe!");
        uint index = getMedicamento(CPF, _codigoMedicamento);
        delete registroMedicamentos[CPF][index];
        return true;
    }
    
    
    
    /*
    *FUNCOES DE BUSCA
    */
    //Buscar Paciente
    function verPaciente(uint CPF) public view returns (Paciente memory) {
        require(chaveCpfId[CPF] != 0, "CPF buscado não existe!");
        uint index = chaveCpfId[CPF]-1;
        return registros[index];
    }
    //Buscar Medicamentos do Paciente
    function verMedicamentosPaciente(uint CPF) public view returns (Medicamento[] memory){
        require(chaveCpfId[CPF] != 0, "CPF buscado não existe!");
        //uint index = chaveCpfId[CPF]-1;
        return registroMedicamentos[CPF];
    }
    
    
    /*
    *FUNCOES AUXILIARES
    */
    // Funcao interna utilizada para deletar um Paciente do array registros e pegar o ultimo Paciente do array e colocar no lugar
    function removeNoOrder(uint index) internal {
        registros[index] = registros[registros.length - 1];
        registros.pop();
    }
    
    // Retorna o index de medicamento, dado o CPF do paciente e o codigo do medicamento
    function getMedicamento(uint CPF, uint _codigoMedicamento) internal view returns (uint) {
        for(uint i=0; i<registroMedicamentos[CPF].length; i++){
            if(registroMedicamentos[CPF][i].codigoMedicamento == _codigoMedicamento){
                return i;
            }
        }
    }
    
    
    //Gerar relatorio dos medicamentos utilziados nos ultimos 15 dias
    
}
