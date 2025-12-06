# Guia de Contribuição

## Adicionando um Novo Parser

Este guia mostra como adicionar suporte para um novo formato de e-mail.

### Passo 1: Criar a Classe do Parser

Crie um novo arquivo em `app/services/email_parsers/`:

```ruby
# app/services/email_parsers/novo_fornecedor_parser.rb
module EmailParsers
  class NovoFornecedorParser < BaseParser
    def extract_customer_info
      body_text = body

      {
        name: extract_name(body_text),
        email: extract_email_field(body_text),
        phone: extract_phone_field(body_text),
        product_code: extract_product_code(body_text),
        subject: subject
      }
    end

    private

    def extract_name(text)
    end

    def extract_email_field(text)
    end

    def extract_phone_field(text)
    end
  end
end
```

### Passo 2: Registrar o Parser

Adicione o mapeamento em `app/services/email_processor_service.rb`:

```ruby
PARSER_MAPPING = {
  'loja@fornecedorA.com' => EmailParsers::FornecedorAParser,
  'contato@parceiroB.com' => EmailParsers::ParceiroBParser,
  'novo@fornecedor.com' => EmailParsers::NovoFornecedorParser  # Adicione aqui
}.freeze
```

### Passo 3: Criar Testes

Crie os testes em `spec/services/email_parsers/`:

```ruby
# spec/services/email_parsers/novo_fornecedor_parser_spec.rb
require 'rails_helper'

RSpec.describe EmailParsers::NovoFornecedorParser do
  let(:email_content) do
    <<~EMAIL
      From: novo@fornecedor.com
      To: vendas@suaempresa.com
      Subject: Interesse em produto

      Cliente: João Silva
      Email: joao@example.com
      Telefone: 11 99999-9999
      Produto: PROD-123
    EMAIL
  end
  
  let(:parser) { described_class.new(email_content) }

  describe '#extract_customer_info' do
    it 'extracts all customer information correctly' do
      result = parser.extract_customer_info

      expect(result[:name]).to eq('João Silva')
      expect(result[:email]).to eq('joao@example.com')
      expect(result[:phone]).to eq('11 99999-9999')
      expect(result[:product_code]).to eq('PROD-123')
    end
  end
end
```

### Passo 4: Executar os Testes

```bash
docker-compose run --rm web bundle exec rspec spec/services/email_parsers/novo_fornecedor_parser_spec.rb
```

### Passo 5: Testar na Aplicação

1. Crie um arquivo `.eml` de exemplo em `emails/`
2. Faça upload pela interface web
3. Verifique os logs de processamento

## Métodos Auxiliares Disponíveis

A classe `BaseParser` fornece métodos auxiliares:

- `extract_email(text)` - Extrai endereços de email
- `extract_phone(text)` - Extrai números de telefone brasileiros
- `extract_product_code(text)` - Extrai códigos de produto (padrão: ABC123, PROD-555)
- `sender` - Retorna o remetente do email
- `subject` - Retorna o assunto do email
- `body` - Retorna o corpo do email em texto plano
- `valid_contact_info?(data)` - Valida se há pelo menos email ou telefone

## Padrões de Código

- Use `frozen_string_literal: true` em todos os arquivos Ruby
- Siga as convenções do RuboCop
- Mantenha os métodos pequenos e focados
- Documente comportamentos não óbvios
- Sempre escreva testes

## Executando Testes

```bash
# Todos os testes
docker-compose run --rm web bundle exec rspec

# Testes específicos
docker-compose run --rm web bundle exec rspec spec/models
docker-compose run --rm web bundle exec rspec spec/services

# Com cobertura
docker-compose run --rm web bundle exec rspec
# Veja coverage/index.html
```

## Estrutura do Projeto

```
app/
├── controllers/       # Controllers Rails
├── jobs/             # Sidekiq jobs
├── models/           # Models ActiveRecord
├── services/         # Lógica de negócio
│   └── email_parsers/  # Parsers de email
└── views/            # Views ERB

spec/
├── factories/        # FactoryBot factories
├── jobs/            # Testes de jobs
├── models/          # Testes de models
└── services/        # Testes de services
```

## Dúvidas?

Consulte o README.md principal ou abra uma issue no repositório.
