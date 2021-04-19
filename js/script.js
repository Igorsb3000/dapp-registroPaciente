// ENDEREÇO EHTEREUM DO CONTRATO
var contractAddress = "0xdC654E5f5269552A912Cb08b163Dd38083f543D9";

// Inicializa o objeto DApp
document.addEventListener("DOMContentLoaded", onDocumentLoad);
function onDocumentLoad() {
  DApp.init();
}

// Nosso objeto DApp que irá armazenar a instância web3
const DApp = {
  web3: null,
  contracts: {},
  account: null,

  init: function () {
    return DApp.initWeb3();
  },

  // Inicializa o provedor web3
  initWeb3: async function () {
    if (typeof window.ethereum !== "undefined") {
      try {
        const accounts = await window.ethereum.request({ // Requisita primeiro acesso ao Metamask
          method: "eth_requestAccounts",
        });
        DApp.account = accounts[0];
        window.ethereum.on('accountsChanged', DApp.updateAccount); // Atualiza se o usuário trcar de conta no Metamaslk
      } catch (error) {
        console.error("Usuário negou acesso ao web3!");
        return;
      }
      DApp.web3 = new Web3(window.ethereum);
    } else {
      console.error("Instalar MetaMask!");
      return;
    }
    return DApp.initContract();
  },

  // Atualiza 'DApp.account' para a conta ativa no Metamask
  updateAccount: async function() {
    DApp.account = (await DApp.web3.eth.getAccounts())[0];
    atualizaInterface();
  },

  // Associa ao endereço do seu contrato
  initContract: async function () {
    DApp.contracts.registrosPaciente = new DApp.web3.eth.Contract(abi, contractAddress);
    return DApp.render();
  },

  // Inicializa a interface HTML com os dados obtidos
  render: async function () {
    inicializaInterface();
  },
};


// *** MÉTODOS (de consulta - view) DO CONTRATO ** //

function verPaciente() {
  let CPFverPaciente = document.getElementById("CPFverPaciente").value;
  return DApp.contracts.registrosPaciente.methods.verPaciente(CPFverPaciente).call({ from: DApp.account });
}

function verMedicamentosPaciente() {
  let CPFverPaciente = document.getElementById("CPFverMedicamentos").value;
  return DApp.contracts.registrosPaciente.methods.verMedicamentosPaciente(CPFverPaciente).call();
}

function verDataInicioEFimMedicamento() {
  let CPFPaciente = document.getElementById("CPFDataInicioFimMedicamento").value;
  let CodigoMedicamento = document.getElementById("CodigoDataInicioFimMedicamento").value;
  return DApp.contracts.registrosPaciente.methods.verDataInicioEFimMedicamento(CPFPaciente, CodigoMedicamento).call();
}

function verUltimoMedicamento() {
  let CPFPaciente = document.getElementById("CPFUltimoMedicamento").value;
  return DApp.contracts.registrosPaciente.methods.verUltimoMedicamento(CPFPaciente).call();
}


// *** ATUALIZAÇÃO DO HTML *** //

function verPacienteATT(){
  verPaciente().then((result) => {
    console.log(result)
    document.getElementById("ver-paciente").innerHTML = "Nome: "+result[0]+", CPF: "+result[1]+", Nasc: "+result[2]+", Sexo: "+result[3];
  });
}

function verPacienteMedicamentoATT(){
  verMedicamentosPaciente().then((result) => {
    let myString = "";
    for(let i=1; i <= result.length ; i++){
      myString += " Medicamento " + i + "-> Médico: " + result[i-1][0]+", Código: " + result[i-1][1] + ", "+ result[i-1][2] + " | ";   
    }
    document.getElementById("medicamentos-paciente").innerHTML = myString;
  });
}

function verInicioFimMedicamentoATT(){
  verDataInicioEFimMedicamento().then((result) => {
    console.log(result);
    let myDate = "Inicio: " + result[0] + ", Fim: " + result[1];
    document.getElementById("data-inicio-fim-medicamento").innerHTML = myDate;
  });
}

function verUltimoMedicamentoATT(){
  verUltimoMedicamento().then((result) => {
    console.log(result);
    document.getElementById("ultimo-medicamento").innerHTML = "Médico: "+result[0]+", Código Medicamento: "+result[1]+", Medicamento: "+result[2];
  });
}


// *** MÉTODOS (de escrita) DO CONTRATO ** //

function cadastrarPaciente(){
  let nomePaciete = document.getElementById("NomeCadastrarPaciente").value;
  let CPFPaciente = document.getElementById("CPFCadastrarPaciente").value;
  let DataNascimentoPaciente = document.getElementById("DataNascimentoCadastrarPaciente").value;
  let SexoPaciente = document.getElementById("SexoCadastrarPaciente").value;
  return DApp.contracts.registrosPaciente.methods.cadastrarPaciente(nomePaciete, CPFPaciente, DataNascimentoPaciente, SexoPaciente).send({ from: DApp.account });
}

function cadastrarMedicamento(){
  let CPFPaciente = document.getElementById("CPFCadastrarMedicamento").value;
  let NomeMedico = document.getElementById("MedicoCadastrarMedicamento").value;
  let CodigoMedicamento = document.getElementById("CodigoMedicamentoCadastrarMedicamento").value;
  let NomeMedicamento = document.getElementById("NomeMedicamentoCadastrarMedicamento").value;
  let DataInicio = document.getElementById("inicioCadastrarMedicamento").value;
  let DataFim = document.getElementById("fimCadastrarMedicamento").value;
  return DApp.contracts.registrosPaciente.methods.cadastrarMedicamento(CPFPaciente, NomeMedico, CodigoMedicamento, NomeMedicamento, DataInicio, DataFim).send({ from: DApp.account });
}

function deletarPaciente(){
  let CPFPaciente = document.getElementById("CPFDeletarPaciente").value;
  return DApp.contracts.registrosPaciente.methods.deletarPaciente(CPFPaciente).send({ from: DApp.account });
}

function deletarMedicamentoPaciente(){
  let CPFPaciente = document.getElementById("CPFDeletarMedicamentoPaciente").value;
  let CodigoMedicamento = document.getElementById("CodigoMedicamentoDeletarPaciente").value;
  return DApp.contracts.registrosPaciente.methods.deletarMedicamentoPaciente(CPFPaciente, CodigoMedicamento).send({ from: DApp.account });
}

function editarPaciente(){
  let CPFPaciente = document.getElementById("CPFEditarPaciente").value;
  let nomePaciente = document.getElementById("NomeEditarPaciente").value;
  let DataNascPaciente = document.getElementById("DataNascimentoEditarPaciente").value;
  let SexoPaciente = document.getElementById("SexoEditarPaciente").value;
  return DApp.contracts.registrosPaciente.methods.editarPaciente(CPFPaciente, nomePaciente, DataNascPaciente, SexoPaciente).send({ from: DApp.account });
}

function editarMedicamento(){
  let CPFPaciente = document.getElementById("CPFEditarMedicamento").value;
  let CodigoMedicamento = document.getElementById("CodigoMedicamentoEditarMedicamento").value;
  let Medico = document.getElementById("nomeMedicoEditarMedicamento").value;
  let Medicamento = document.getElementById("MedicamentoEditarMedicamento").value;
  let DataInicio = document.getElementById("DataInicioEditarMedicamento").value;
  let DataFim = document.getElementById("DataFimEditarMedicamento").value;
  return DApp.contracts.registrosPaciente.methods.editarMedicamento(CPFPaciente, CodigoMedicamento, Medico, Medicamento, DataInicio, DataFim).send({ from: DApp.account });
}


// *** APERTOU NO BOTÃO *** //
function inicializaInterface() {
  document.getElementById("sendverPaciente").onclick = verPacienteATT;
  document.getElementById("sendverMedicamentos").onclick = verPacienteMedicamentoATT;
  document.getElementById("sendverInicioFimMedicamento").onclick = verInicioFimMedicamentoATT;
  document.getElementById("sendverUltimoMedicamento").onclick = verUltimoMedicamentoATT;
  document.getElementById("sendCadastrarPaciente").onclick = cadastrarPaciente;
  document.getElementById("sendCadastrarMedicamento").onclick = cadastrarMedicamento;
  document.getElementById("sendDeletarPaciente").onclick = deletarPaciente;
  document.getElementById("sendDeletarMedicamentoPaciente").onclick = deletarMedicamentoPaciente;
  document.getElementById("sendEditarPaciente").onclick = editarPaciente;
  document.getElementById("sendEditarMedicamento").onclick = editarMedicamento;

    // Eventos Paciente
  DApp.contracts.registrosPaciente.getPastEvents("pacienteCadastrado", { fromBlock: 0, toBlock: "latest" }).then((result) => registraEventoPaciente(result)); 
  DApp.contracts.registrosPaciente.events.pacienteCadastrado((error, event) => registraEventoPaciente([event]));  

  DApp.contracts.registrosPaciente.getPastEvents("pacienteDeletado", { fromBlock: 0, toBlock: "latest" }).then((result) => registraEventoPaciente(result));
  DApp.contracts.registrosPaciente.events.pacienteDeletado((error, event) => registraEventoPaciente([event])); 

  DApp.contracts.registrosPaciente.getPastEvents("pacienteAlterado", { fromBlock: 0, toBlock: "latest" }).then((result) => registraEventoPaciente(result));
  DApp.contracts.registrosPaciente.events.pacienteAlterado((error, event) => registraEventoPaciente([event]));

  // Eventos Medicamentos
  DApp.contracts.registrosPaciente.getPastEvents("medicamentoCadastrado", { fromBlock: 0, toBlock: "latest" }).then((result) => registraEventoMedicamento(result)); 
  DApp.contracts.registrosPaciente.events.medicamentoCadastrado((error, event) => registraEventoMedicamento([event]));

  DApp.contracts.registrosPaciente.getPastEvents("medicamentoDeletado", { fromBlock: 0, toBlock: "latest" }).then((result) => registraEventoMedicamento(result)); 
  DApp.contracts.registrosPaciente.events.medicamentoDeletado((error, event) => registraEventoMedicamento([event]));  

  DApp.contracts.registrosPaciente.getPastEvents("medicamentoAlterado", { fromBlock: 0, toBlock: "latest" }).then((result) => registraEventoMedicamento(result)); 
  DApp.contracts.registrosPaciente.events.medicamentoAlterado((error, event) => registraEventoMedicamento([event]));  
  
}

// *** REGISTRAR EVENTOS *** //
function registraEventoPaciente(eventos) {
  let table = document.getElementById("events");
  eventos.forEach(evento => {
    let tr = document.createElement("tr");
    let td1 = document.createElement("td");
    td1.innerHTML = "Paciente";
    let td2 = document.createElement("td");
    td2.innerHTML = evento["returnValues"]["nome"];
    let td3 = document.createElement("td");
    td3.innerHTML = evento["returnValues"]["CPF"] + " (CPF)";
    let td4 = document.createElement("td");
    td4.innerHTML = evento["returnValues"]["tipoAcao"];
    let td5 = document.createElement("td");  
    td5.innerHTML = "<a href='https://ropsten.etherscan.io/tx/"+ evento["transactionHash"] +"'>" + evento["transactionHash"] + "</a>";
    tr.appendChild(td1);
    tr.appendChild(td2);
    tr.appendChild(td3);
    tr.appendChild(td4);
    tr.appendChild(td5);
    table.appendChild(tr);
  });
}

function registraEventoMedicamento(eventos) {
  let table = document.getElementById("events");
  eventos.forEach(evento => {
    let tr = document.createElement("tr");
    let td1 = document.createElement("td");
    td1.innerHTML = "Medicamento";
    let td2 = document.createElement("td");
    td2.innerHTML = evento["returnValues"]["nomeMedicamento"];
    let td3 = document.createElement("td");
    td3.innerHTML = evento["returnValues"]["id"] + " (ID)";
    let td4 = document.createElement("td");
    td4.innerHTML = evento["returnValues"]["tipoAcao"];
    let td5 = document.createElement("td");  
    td5.innerHTML = "<a href='https://ropsten.etherscan.io/tx/"+ evento["transactionHash"] +"'>" + evento["transactionHash"] + "</a>";
    tr.appendChild(td1);
    tr.appendChild(td2);
    tr.appendChild(td3);
    tr.appendChild(td4);
    tr.appendChild(td5);
    table.appendChild(tr);
  });
}