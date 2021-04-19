// Nome: Wesley Gurgel Marcelino de Oliveira
// Nome: Igor Silva Bento
// Conta do contrato:

pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2; //usado para tentar retornar a struct Paciente

import "./Owned.sol";

contract RegistroPaciente is Mortal {

    // Eventos
    event pacienteCadastrado(string nome, uint CPF, string tipoAcao);
    event pacienteDeletado(string nome, uint CPF, string tipoAcao);
    event pacienteAlterado(string nome, uint CPF, string tipoAcao);
    
    event medicamentoCadastrado(uint id, string nomeMedicamento, string dataInicioTratamento, string dataFimTratamento, string tipoAcao);
    event medicamentoDeletado(uint CPF, uint idMedicamento, string nomeMedicamento, string tipoAcao);
    event medicamentoAlterado(uint CPF, uint idMedicamento, string nomeMedicamento, string tipoAcao);
    
    // Características de um paciente, dados obrigatórios para o cadastro
    struct Paciente {
        string nome;
        uint CPF;
        string dataNascimento;
        string sexo;
    }
    
    // Características do medicamento, dados obrigatórios para o cadastro
    struct Medicamento {
        string nomeMedicoReceitou;
        uint codigoMedicamento;
        string nomeMedicamento;
        string dataInicioTratamento;
        string dataFimTratamento;
    }
    
    // Cada CPF (paciente) possui um array de registros de medicamentos
    mapping (uint => Medicamento[]) registroMedicamentos;
    
    // CPF => index no array registros
    mapping (uint => uint) chaveCpfId;
    
    // Array com todos os pacientes cadastrados
    Paciente[] public registros;
    
    /*
    *FUNCOES DE CADASTRO
    */
    //Cadastrar Paciente
    function cadastrarPaciente(string memory _nome, uint _CPF, string memory _dataNascimento, string memory _sexo) public {
        registros.push(Paciente(_nome,_CPF,_dataNascimento, _sexo));
        chaveCpfId[_CPF] = registros.length;
        string memory tipoAcao = "cadastrar";
        emit pacienteCadastrado(_nome, _CPF, tipoAcao);
    }
    
    //Cadastrar remedios receitados ao Paciente
    function cadastrarMedicamento(uint CPF, string memory _nomeMedicoReceitou, uint _codigoMedicamento, 
    string memory _nomeMedicamento, string memory _dataInicioTratamento, string memory _dataFimTratamento) public {
        require(chaveCpfId[CPF] != 0, "CPF buscado não existe!");
        registroMedicamentos[CPF].push(Medicamento(_nomeMedicoReceitou, _codigoMedicamento, _nomeMedicamento, _dataInicioTratamento, _dataFimTratamento));
        string memory tipoAcao = "cadastrar";
        emit medicamentoCadastrado(_codigoMedicamento, _nomeMedicamento, _dataInicioTratamento, _dataFimTratamento, tipoAcao);
        
    }
    
    /*
    *FUNCOES DE EDITACAO
    */
    // Editar registro do paciente, apenas nao eh permitido edicao do CPF
    // Caso o CPF tenha sido inserido errado, delete o registro e realize o cadastro novamente
    function editarPaciente(uint _CPF, string memory _nome, string memory _dataNascimento, string memory _sexo) public {
        require(chaveCpfId[_CPF] != 0, "CPF buscado não existe!");
        uint index = chaveCpfId[_CPF]-1;
        registros[index].nome = _nome;
        registros[index].dataNascimento = _dataNascimento;
        registros[index].sexo = _sexo;
        string memory tipoAcao = "editar";
        emit pacienteAlterado(registros[index].nome, registros[index].CPF, tipoAcao);
    }
    
    // Editar Medicamento especifico, precisa-se do codigo do medicamento e CPF para encontrar o paciente
    // Eh realizada a edicao de todos os parametros exceto o codigo do medicamento, em caso de erro no codigo do medicmento recomenda-se
    // deletar o cadastro do medicamento e realizar o cadastro novamente
    function editarMedicamento(uint CPF, uint _codigoMedicamento, string memory _nomeMedicoReceitou, 
    string memory _nomeMedicamento, string memory _dataInicioTratamento, string memory _dataFimTratamento) public {
        require(chaveCpfId[CPF] != 0, "CPF buscado não existe!");
        uint index = getMedicamento(CPF, _codigoMedicamento);
        registroMedicamentos[CPF][index].nomeMedicoReceitou = _nomeMedicoReceitou;
        registroMedicamentos[CPF][index].nomeMedicamento = _nomeMedicamento;
        registroMedicamentos[CPF][index].dataInicioTratamento = _dataInicioTratamento;
        registroMedicamentos[CPF][index].dataFimTratamento = _dataFimTratamento;
        string memory tipoAcao = "editar";
        emit medicamentoAlterado(registros[chaveCpfId[CPF]-1].CPF, registroMedicamentos[CPF][index].codigoMedicamento, 
        registroMedicamentos[CPF][index].nomeMedicamento, tipoAcao);
    }
    
    
    /*
    *FUNCOES DE EXCLUSAO
    */
    //Excluir paciente dos registros
    function deletarPaciente(uint _CPF) public {
        require(chaveCpfId[_CPF] != 0, "CPF buscado não existe!");
        uint index = chaveCpfId[_CPF]-1;
        string memory nomeDeletado = registros[index].nome;
        uint CPFDeletado = registros[index].CPF;
        uint CPF_ultimo_cadastrado = registros[registros.length-1].CPF;
        // Remove do array registros o pacinte do indice (index), copia o o ultimo registro do array 
        // para o lugar delete e faz o pop(), removendo o ultimo elemento do array
        removeNoOrder(index);
        chaveCpfId[CPF_ultimo_cadastrado] = index+1;
        delete chaveCpfId[_CPF];
        delete registroMedicamentos[_CPF];
        string memory tipoAcao = "excluir";
        emit pacienteDeletado(nomeDeletado, CPFDeletado, tipoAcao);
        
    }
    // Excluir um medicamento, atraves do CPF do paciente e codigo do medicamento cadastrado
    function deletarMedicamentoPaciente(uint CPF, uint _codigoMedicamento) public {
        require(chaveCpfId[CPF] != 0, "CPF buscado não existe!");
        uint index = getMedicamento(CPF, _codigoMedicamento);
        uint i = chaveCpfId[CPF]-1;
        uint CPFpaciente = registros[i].CPF;
        uint codigoMedicamento = registroMedicamentos[CPF][index].codigoMedicamento;
        string memory nomeMedicamento = registroMedicamentos[CPF][index].nomeMedicamento;
        removeMedicamentoInOrder(CPF, index);
        string memory tipoAcao = "excluir";
        emit medicamentoDeletado(CPFpaciente, codigoMedicamento, nomeMedicamento, tipoAcao);
    }
    
    
    
    /*
    *FUNCOES DE BUSCA
    */
    //Buscar Paciente
    function verPaciente(uint CPF) public view returns (string memory, uint, string memory, string memory) {//Paciente memory
        require(chaveCpfId[CPF] != 0, "CPF buscado não existe!");
        uint index = chaveCpfId[CPF]-1;
        //return registros[index];
        return (registros[index].nome, registros[index].CPF, registros[index].dataNascimento, registros[index].sexo);
    }
    //Buscar Medicamentos do Paciente
    function verMedicamentosPaciente(uint CPF) public view returns (Medicamento[] memory){
        require(chaveCpfId[CPF] != 0, "CPF buscado não existe!");
        require(registroMedicamentos[CPF].length != 0, "Paciente não possui medicamentos cadastrados");
        return registroMedicamentos[CPF];
    }
    
    // Retorna a data de inicio e fim do tratamento de um medicamento, dado o CPF do paciente e o codigo do medicamento
    function verDataInicioEFimMedicamento(uint CPF, uint _codigoMedicamento) public view returns (string memory, string memory) {
        require(chaveCpfId[CPF] != 0, "CPF buscado não existe!");
        require(registroMedicamentos[CPF].length != 0, "Paciente não possui medicamentos cadastrados");
        uint index = getMedicamento(CPF, _codigoMedicamento);
        return (registroMedicamentos[CPF][index].dataInicioTratamento, registroMedicamentos[CPF][index].dataFimTratamento);
    }
    // Retorna o ultimo medicamento cadastrado para um determinado paciente
    function verUltimoMedicamento(uint CPF) public view returns (string memory, uint, string memory, string memory, string memory){ //todo Medicamento memory
        require(chaveCpfId[CPF] != 0, "CPF buscado não existe!");
        require(registroMedicamentos[CPF].length != 0, "Paciente não possui medicamentos cadastrados");
        uint index = registroMedicamentos[CPF].length-1;
        //return registroMedicamentos[CPF][index];

        return (registroMedicamentos[CPF][index].nomeMedicoReceitou, registroMedicamentos[CPF][index].codigoMedicamento, 
        registroMedicamentos[CPF][index].nomeMedicamento, registroMedicamentos[CPF][index].dataInicioTratamento, registroMedicamentos[CPF][index].dataFimTratamento);
    }
    
    /*
    *FUNCOES AUXILIARES
    */
    // Funcao interna utilizada para deletar um Paciente do array registros e pegar o ultimo Paciente do array e colocar no lugar
    function removeNoOrder(uint index) internal {
        registros[index] = registros[registros.length - 1];
        registros.pop();
    }
    
    function removeMedicamentoInOrder(uint CPF, uint index) internal {
        for (uint i=index; i< registroMedicamentos[CPF].length-1; i++) {
            registroMedicamentos[CPF][i] = registroMedicamentos[CPF][i+1];
        }
        registroMedicamentos[CPF].pop();
    }
    
    // Retorna o index de medicamento, dado o CPF do paciente e o codigo do medicamento
    function getMedicamento(uint CPF, uint _codigoMedicamento) internal view returns (uint) {
        for(uint i=0; i<registroMedicamentos[CPF].length; i++){
            if(registroMedicamentos[CPF][i].codigoMedicamento == _codigoMedicamento){
                return i;
            }
        }
    }
    
    
}
