var abi = [
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "id",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "nomeMedicamento",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "dataInicioTratamento",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "dataFimTratamento",
				"type": "string"
			}
		],
		"name": "medicamentoCadastrado",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "string",
				"name": "nome",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "CPF",
				"type": "uint256"
			}
		],
		"name": "pacienteCadastrado",
		"type": "event"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "CPF",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "_nomeMedicoReceitou",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "_codigoMedicamento",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "_nomeMedicamento",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_dataInicioTratamento",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_dataFimTratamento",
				"type": "string"
			}
		],
		"name": "cadastrarMedicamento",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "string",
				"name": "_nome",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "_CPF",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "_dataNascimento",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_sexo",
				"type": "string"
			}
		],
		"name": "cadastrarPaciente",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "CPF",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_codigoMedicamento",
				"type": "uint256"
			}
		],
		"name": "deletarMedicamentoPaciente",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "CPF",
				"type": "uint256"
			}
		],
		"name": "deletarPaciente",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "destroy",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "CPF",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_codigoMedicamento",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "_nomeMedicoReceitou",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_nomeMedicamento",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_dataInicioTratamento",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_dataFimTratamento",
				"type": "string"
			}
		],
		"name": "editarMedicamento",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_CPF",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "_nome",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_dataNascimento",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_sexo",
				"type": "string"
			}
		],
		"name": "editarPaciente",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "registros",
		"outputs": [
			{
				"internalType": "string",
				"name": "nome",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "CPF",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "dataNascimento",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "sexo",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "CPF",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "_codigoMedicamento",
				"type": "uint256"
			}
		],
		"name": "verDataInicioEFimMedicamento",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "CPF",
				"type": "uint256"
			}
		],
		"name": "verMedicamentosPaciente",
		"outputs": [
			{
				"components": [
					{
						"internalType": "string",
						"name": "nomeMedicoReceitou",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "codigoMedicamento",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "nomeMedicamento",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "dataInicioTratamento",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "dataFimTratamento",
						"type": "string"
					}
				],
				"internalType": "struct RegistroPaciente.Medicamento[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "CPF",
				"type": "uint256"
			}
		],
		"name": "verPaciente",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "CPF",
				"type": "uint256"
			}
		],
		"name": "verUltimoMedicamento",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
]