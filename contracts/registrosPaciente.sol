// Nome: Wesley Gurgel Marcelino de Oliveira
// Nome: Igor Silva Bento
// Conta do contrato:

pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2; //usado para tentar retornar a struct Paciente

import "./Owned.sol";

contract RegistroPaciente is Mortal {
    
    modifier onlyDoctor {
        require(chaveCrmId[enderecoParaCRM[msg.sender]] != 0, "Médico não registrado no sistema!");
        _; 
    }

    // Eventos
    event medicoCadastrado(string nome, uint CRM, string tipoAcao);
    event medicoDeletado(string nome, uint CRM, string tipoAcao);
    event medicoAlterado(string nome, uint CRM, string tipoAcao);
    
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
    
    // Características de um médico, dados obrigatórios para o cadastro
    struct Medico {
        address endereco;
        string nome;
        uint CRM;
        string especialidade;
        string municipioLotacao;
    }
    
    // Características do medicamento, dados obrigatórios para o cadastro
    struct Medicamento {
        string nomeMedicoReceitou;
        uint codigoMedicamento;
        string nomeMedicamento;
        string dataInicioTratamento;
        string dataFimTratamento;
    }
    
    // Endereco do medico => CRM
    mapping (address => uint) enderecoParaCRM;
    
    // CRM => index no array medicos
    mapping (uint => uint) chaveCrmId;
    
    // Array com todos os medicos cadastrados    
    Medico[] public medicos;
    
    
    // Cada CPF (paciente) possui um array de registros de medicamentos
    mapping (uint => Medicamento[]) registroMedicamentos;
    
    // CPF => index no array registros
    mapping (uint => uint) chaveCpfId;
    
    
    // Array com todos os pacientes cadastrados
    Paciente[] public registros;
    
    
   // Funcao utilizada no front-end para mostrar funcoes exclusivas dos medicos
   function isDoctor() public view returns (bool) {
       if(chaveCrmId[enderecoParaCRM[msg.sender]] != 0) {
           return true;
       }
       return false;
   }
   
   // Funcao utilizada no front-end para mostrar funcoes exclusivas do dono do contrato
   function isOwner () public view returns (bool) {
       if (msg.sender == owner) {
           return true;
       }
       return false;
   }
    
    
    /*
    *FUNCOES DE CADASTRO
    */
    //Cadastrar Paciente
    function cadastrarPaciente(string memory _nome, uint _CPF, string memory _dataNascimento, string memory _sexo) public onlyDoctor {
        registros.push(Paciente(_nome, _CPF, _dataNascimento, _sexo));
        chaveCpfId[_CPF] = registros.length;
        string memory tipoAcao = "CADASTRAR";
        emit pacienteCadastrado(_nome, _CPF, tipoAcao);
    }
    
    //Cadastrar remedios receitados ao Paciente
    function cadastrarMedicamento(uint CPF, uint _codigoMedicamento, string memory _nomeMedicamento, string memory _dataInicioTratamento, string memory _dataFimTratamento) public onlyDoctor {
        require(chaveCpfId[CPF] != 0, "CPF buscado não existe!");
        uint index = chaveCrmId[enderecoParaCRM[msg.sender]]-1;
        string memory _nomeMedicoReceitou = medicos[index].nome;
        registroMedicamentos[CPF].push(Medicamento(_nomeMedicoReceitou, _codigoMedicamento, _nomeMedicamento, _dataInicioTratamento, _dataFimTratamento));
        string memory tipoAcao = "CADASTRAR";
        emit medicamentoCadastrado(_codigoMedicamento, _nomeMedicamento, _dataInicioTratamento, _dataFimTratamento, tipoAcao);
    }
    
    function cadastrarMedico(address _endereco, string memory _nome, uint _CRM, string memory _especialidade, string memory _municipioLotacao) public onlyOwner {
        medicos.push(Medico(_endereco, _nome, _CRM, _especialidade, _municipioLotacao));
        chaveCrmId[_CRM] = medicos.length;
        enderecoParaCRM[_endereco] = _CRM;
        string memory tipoAcao = "CADASTRAR";
        emit medicoCadastrado(_nome, _CRM, tipoAcao);
    }
    
    
    /*
    *FUNCOES DE EDITACAO
    */
    // Editar registro do paciente, apenas nao eh permitido edicao do CPF
    // Caso o CPF tenha sido inserido errado, delete o registro e realize o cadastro novamente
    function editarPaciente(uint _CPF, string memory _nome, string memory _dataNascimento, string memory _sexo) public onlyDoctor {
        require(chaveCpfId[_CPF] != 0, "CPF buscado não existe!");
        uint index = chaveCpfId[_CPF]-1;
        registros[index].nome = _nome;
        registros[index].dataNascimento = _dataNascimento;
        registros[index].sexo = _sexo;
        string memory tipoAcao = "EDITAR";
        emit pacienteAlterado(registros[index].nome, registros[index].CPF, tipoAcao);
    }
    
    // Editar Medicamento especifico, precisa-se do codigo do medicamento e CPF para encontrar o paciente
    // Eh realizada a edicao de todos os parametros exceto o codigo do medicamento, em caso de erro no codigo do medicmento recomenda-se
    // deletar o cadastro do medicamento e realizar o cadastro novamente
    function editarMedicamento(uint CPF, uint _codigoMedicamento, string memory _nomeMedicamento, string memory _dataInicioTratamento, string memory _dataFimTratamento) public onlyDoctor{
        require(chaveCpfId[CPF] != 0, "CPF buscado não existe!");
        uint indexMedico = chaveCrmId[enderecoParaCRM[msg.sender]]-1; //Colocamos o nome do médico que editou o medicamento, pois pode ser outro médico
        uint index = getMedicamento(CPF, _codigoMedicamento);
        registroMedicamentos[CPF][index].nomeMedicoReceitou = medicos[indexMedico].nome;
        registroMedicamentos[CPF][index].nomeMedicamento = _nomeMedicamento;
        registroMedicamentos[CPF][index].dataInicioTratamento = _dataInicioTratamento;
        registroMedicamentos[CPF][index].dataFimTratamento = _dataFimTratamento;
        string memory tipoAcao = "EDITAR";
        emit medicamentoAlterado(registros[chaveCpfId[CPF]-1].CPF, registroMedicamentos[CPF][index].codigoMedicamento, 
        registroMedicamentos[CPF][index].nomeMedicamento, tipoAcao);
    }
    
    // Editar dados do medico cadastrado, não é possivel editar o CRM
    // Em caso de erro no CRM delete o medico e faça o cadastro dele novamente
    function editarMedico(uint CRM, string memory _nome, string memory _especialidade, string memory _municipioLotacao) public onlyOwner {
        require(chaveCrmId[CRM] != 0, "CRM buscado não existe");
        uint index = chaveCrmId[CRM]-1;
        medicos[index].nome = _nome;
        medicos[index].especialidade = _especialidade;
        medicos[index].municipioLotacao = _municipioLotacao;
        string memory tipoAcao = "EDITAR";
        emit medicoAlterado(medicos[index].nome, medicos[index].CRM, tipoAcao);
    }
        
    
    /*
    *FUNCOES DE EXCLUSAO
    */
    //Excluir paciente dos registros
    function deletarPaciente(uint _CPF) public onlyDoctor {
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
        string memory tipoAcao = "EXCLUIR";
        emit pacienteDeletado(nomeDeletado, CPFDeletado, tipoAcao);
    }
    
    // Excluir um medicamento, atraves do CPF do paciente e codigo do medicamento cadastrado
    function deletarMedicamentoPaciente(uint CPF, uint _codigoMedicamento) public onlyDoctor {
        require(chaveCpfId[CPF] != 0, "CPF buscado não existe!");
        uint index = getMedicamento(CPF, _codigoMedicamento);
        uint i = chaveCpfId[CPF]-1;
        uint CPFpaciente = registros[i].CPF;
        uint codigoMedicamento = registroMedicamentos[CPF][index].codigoMedicamento;
        string memory nomeMedicamento = registroMedicamentos[CPF][index].nomeMedicamento;
        removeMedicamentoInOrder(CPF, index);
        string memory tipoAcao = "EXCLUIR";
        emit medicamentoDeletado(CPFpaciente, codigoMedicamento, nomeMedicamento, tipoAcao);
    }
    
    function deletarMedico(uint _CRM) public onlyOwner {
        require(chaveCrmId[_CRM] != 0, "CRM buscado não existe");
        uint index = chaveCrmId[_CRM]-1;
        string memory nomeDeletado = medicos[index].nome;
        uint CRMDeletado = medicos[index].CRM;
        address enderecoDeletado = medicos[index].endereco;
        // Faço isso porque o removeNoOrder vai pegar o ultimo cadastro do array e colcocar no lugar do que será deletado, então é removido
        // o ultimo cadastro do array, é preciso atualizar o ID no chaveCrmId
        uint CRM_ultimo_cadastrado = medicos[medicos.length-1].CRM;
        removeNoOrderDoctor(index);
        chaveCrmId[CRM_ultimo_cadastrado] = index+1;
        delete enderecoParaCRM[enderecoDeletado];
        delete chaveCrmId[_CRM];
        string memory tipoAcao = "EXCLUIR";
        emit medicoDeletado(nomeDeletado, CRMDeletado, tipoAcao);
    }
    
    
    
    /*
    *FUNCOES DE BUSCA
    */
    //Buscar Paciente
    function verPaciente(uint CPF) public view returns (string memory, uint, string memory, string memory) {
        require(chaveCpfId[CPF] != 0, "CPF buscado não existe!");
        uint index = chaveCpfId[CPF]-1;
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
    function verUltimoMedicamento(uint CPF) public view returns (string memory, uint, string memory, string memory, string memory){
        require(chaveCpfId[CPF] != 0, "CPF buscado não existe!");
        require(registroMedicamentos[CPF].length != 0, "Paciente não possui medicamentos cadastrados");
        uint index = registroMedicamentos[CPF].length-1;
        return (registroMedicamentos[CPF][index].nomeMedicoReceitou, registroMedicamentos[CPF][index].codigoMedicamento, 
        registroMedicamentos[CPF][index].nomeMedicamento, registroMedicamentos[CPF][index].dataInicioTratamento, registroMedicamentos[CPF][index].dataFimTratamento);
    }
    
    // Retorna o Medico de acordo com o CRM passado por parametro
    function verMedicoPorCRM(uint _CRM) public view returns (string memory) {
        require(chaveCrmId[_CRM] != 0, "CRM buscado não existe");
        uint index = chaveCrmId[_CRM]-1;
        return medicos[index].nome;
    }
    
    // Retorna o array como todos os medicos cadastrados
    function verTodosMedicos() public view returns (Medico[] memory) {
        require(medicos.length != 0, "O sistema não possui nenhum médico cadastrado!");
        return medicos;
    }
    
    
    /*
    *FUNCAO PARA GERAR RELATORIO DE UM PACIENTE
    */
    function gerarRelatorioPaciente(uint _CPF) public onlyDoctor view returns (Paciente memory, Medicamento[] memory) {
        require(chaveCpfId[_CPF] != 0, "CPF buscado não existe!");
        uint index = chaveCpfId[_CPF]-1;
        return (registros[index], registroMedicamentos[_CPF]);
    }
    
    
    /*
    *FUNCOES AUXILIARES
    */
    // Funcao interna utilizada para deletar um Paciente do array registros e pegar o ultimo Paciente do array e colocar no lugar
    function removeNoOrder(uint index) internal {
        registros[index] = registros[registros.length - 1];
        registros.pop();
    }
    
    // Funcao interna utilizada para deletar um Médico do array medicos e pegar o ultimo Médico do array e colocar no lugar
    function removeNoOrderDoctor(uint index) internal {
        medicos[index] = medicos[medicos.length - 1];
        medicos.pop();
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
