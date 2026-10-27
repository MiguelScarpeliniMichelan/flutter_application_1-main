import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: FormularioExemplo()));

class Pet {
  final String nome;
  final String especie;
  final int idade;
  final bool castrado;

  Pet({
    required this.nome,
    required this.especie,
    required this.idade,
    required this.castrado,
  });
}

class ListaPetsScreen extends StatelessWidget {
  final List<Pet> pets;

  const ListaPetsScreen({super.key, required this.pets});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pets Cadastrados')),
      body: pets.isEmpty
          ? const Center(child: Text('Nenhum pet cadastrado ainda.'))
          : ListView.builder(
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(pet.nome),
                    subtitle: Text(
                      '${pet.especie} - ${pet.idade} anos'
                      '${pet.castrado ? ' - Castrado' : ''}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class FormularioExemplo extends StatefulWidget {
  const FormularioExemplo({super.key});

  @override
  State<FormularioExemplo> createState() => _FormularioExemploState();
}

class _FormularioExemploState extends State<FormularioExemplo> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _especieController = TextEditingController();
  final _idadeController = TextEditingController();
  final _nomeController = TextEditingController();
  bool _animalCastrado = false;

  final List<Pet> _petsCadastrados = [];

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _especieController.dispose();
    _idadeController.dispose();
    _nomeController.dispose();
    super.dispose();
  }

  void _limparFormulario() {
    _formKey.currentState?.reset();
    setState(() {
      _nomeController.clear();
      _especieController.clear();
      _idadeController.clear();
      _emailController.clear();
      _senhaController.clear();
      _animalCastrado = false;
    });
  }

  void _submeterFormulario() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _petsCadastrados.add(Pet(
          nome: _nomeController.text.trim(),
          especie: _especieController.text,
          idade: int.parse(_idadeController.text),
          castrado: _animalCastrado,
        ));
      });
      _limparFormulario();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro Rápido')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Animal',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Informe o nome do animal!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _especieController.text.isNotEmpty
                    ? _especieController.text
                    : null,
                decoration: const InputDecoration(
                  labelText: 'Espécie',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Cachorro', child: Text('Cachorro')),
                  DropdownMenuItem(value: 'Gato', child: Text('Gato')),
                  DropdownMenuItem(value: 'Peixe', child: Text('Peixe')),
                ],
                onChanged: (value) {
                  setState(() {
                    _especieController.text = value ?? '';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione uma espécie!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _idadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Idade do Animal',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final idade = int.tryParse(value ?? '');
                  if (idade == null || idade < 0) {
                    return 'A idade deve ser um número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Seu animal é castrado?'),
                value: _animalCastrado,
                onChanged: (bool? value) {
                  setState(() {
                    _animalCastrado = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submeterFormulario,
                child: const Text('Cadastrar Animal'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ListaPetsScreen(pets: _petsCadastrados),
                    ),
                  );
                },
                child: const Text('Ver Pets Cadastrados'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}