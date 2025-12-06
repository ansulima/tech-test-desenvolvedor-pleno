# Email Processor - Teste Técnico Desenvolvedor Ruby on Rails (Pleno)

Sistema para processamento de arquivos `.eml` (e-mails) com extração de informações estruturadas de clientes.

## 🚀 Tecnologias Utilizadas

- **Ruby on Rails 8.1**
- **PostgreSQL** - Banco de dados
- **Redis** - Cache e fila de jobs
- **Sidekiq** - Processamento em background
- **RSpec** - Testes automatizados
- **Bootstrap 5** - Interface web
- **Docker & Docker Compose** - Containerização

## 📋 Pré-requisitos

- Docker
- Docker Compose

## 🔧 Instalação e Execução

### 1. Clone o repositório

```bash
git clone <seu-repositorio>
cd tech-test-desenvolvedor-pleno
```

### 2. Construa e inicie os containers

```bash
docker-compose build
docker-compose up
```

Isso irá:
- Criar e configurar o banco de dados PostgreSQL
- Iniciar o Redis
- Instalar todas as dependências
- Executar as migrations
- Iniciar o servidor Rails na porta 3000
- Iniciar o Sidekiq para processar jobs em background

### 3. Acesse a aplicação

Abra seu navegador e acesse:
- **Aplicação principal**: http://localhost:3000
- **Sidekiq Dashboard**: http://localhost:3000/sidekiq

## 📖 Como Usar

### Upload de Arquivos .eml

1. Acesse a página inicial (http://localhost:3000)
2. Clique em "Upload Email" no menu
3. Selecione um arquivo `.eml`
4. Clique em "Upload and Process"
5. O arquivo será processado em background

### Visualizar Customers

1. Clique em "Customers" no menu
2. Veja a lista de todos os clientes extraídos dos e-mails
3. Clique em "View" para ver detalhes de um cliente específico

### Visualizar Logs de Processamento

1. Clique em "Processing Logs" no menu
2. Veja estatísticas de processamento (Total, Sucessos, Falhas)
3. Navegue pela lista de todos os processamentos
4. Clique em "Details" para ver informações detalhadas de cada processamento

## 🏗️ Arquitetura

### Estrutura de Classes Principais

#### 1. EmailProcessorService
Classe principal responsável por:
- Receber o arquivo `.eml`
- Identificar o remetente
- Selecionar o parser apropriado
- Criar registros de Customer
- Gerar logs de processamento

#### 2. EmailParsers::BaseParser
Classe base que define:
- Interface comum para todos os parsers
- Métodos auxiliares para extração (email, telefone, código de produto)
- Validação de informações de contato

#### 3. EmailParsers::FornecedorAParser
Parser específico para e-mails de `loja@fornecedorA.com`
- Extrai informações no formato do Fornecedor A

#### 4. EmailParsers::ParceiroBParser
Parser específico para e-mails de `contato@parceiroB.com`
- Extrai informações no formato do Parceiro B

### Adicionando Novos Parsers

Para adicionar suporte a um novo remetente:

1. Crie uma nova classe em `app/services/email_parsers/`:

```ruby
module EmailParsers
  class NovoFornecedorParser < BaseParser
    def extract_customer_info
      {
        name: extract_name(body),
        email: extract_email(body),
        phone: extract_phone(body),
        product_code: extract_product_code(body),
        subject: subject
      }
    end
  end
end
```

2. Adicione o mapeamento em `EmailProcessorService`:

```ruby
PARSER_MAPPING = {
  'loja@fornecedorA.com' => EmailParsers::FornecedorAParser,
  'contato@parceiroB.com' => EmailParsers::ParceiroBParser,
  'novo@fornecedor.com' => EmailParsers::NovoFornecedorParser # Adicione aqui
}.freeze
```

3. Crie os testes em `spec/services/email_parsers/novo_fornecedor_parser_spec.rb`

Pronto! O sistema automaticamente usará o novo parser.

## 🧪 Testes

### Executar todos os testes

```bash
docker-compose run web bundle exec rspec
```

### Executar testes específicos

```bash
# Testes de modelos
docker-compose run web bundle exec rspec spec/models

# Testes de serviços
docker-compose run web bundle exec rspec spec/services

# Teste específico
docker-compose run web bundle exec rspec spec/services/email_processor_service_spec.rb
```

### Cobertura de Código

Os testes geram um relatório de cobertura em `coverage/index.html`

## 📊 Modelos de Dados

### Customer
- `name` - Nome do cliente (obrigatório)
- `email` - E-mail do cliente
- `phone` - Telefone do cliente
- `product_code` - Código do produto de interesse
- `subject` - Assunto do e-mail

**Validação**: Deve ter pelo menos email OU telefone

### ProcessingLog
- `filename` - Nome do arquivo processado
- `sender` - Remetente do e-mail
- `status` - Status do processamento (success/failed)
- `extracted_data` - Dados extraídos (JSON)
- `error_message` - Mensagem de erro (se houver)
- `customer_id` - Referência ao customer criado
- `processed_at` - Data/hora do processamento

### EmailFile
- `filename` - Nome do arquivo
- `content` - Conteúdo binário do arquivo
- `content_type` - Tipo MIME
- `file_size` - Tamanho em bytes

## 🔄 Background Jobs

### EmailProcessorJob
Processa arquivos de e-mail em background usando Sidekiq

### LogCleanupJob
Remove logs antigos (configurável, padrão: 30 dias)

Para executar manualmente:
```ruby
# No console Rails
LogCleanupJob.perform_async(30) # Remove logs com mais de 30 dias
```

## 🗂️ Arquivos de Exemplo

O projeto inclui 8 arquivos `.eml` de exemplo em `emails/`:

**Fornecedor A** (`loja@fornecedorA.com`):
- `email1.eml` - Completo com todas as informações
- `email2.eml` - Completo com todas as informações
- `email3.eml` - Faltando telefone (deve processar com sucesso)
- `email7.eml` - Faltando email e telefone (deve falhar)

**Parceiro B** (`contato@parceiroB.com`):
- `email4.eml` - Completo com todas as informações
- `email5.eml` - Completo com todas as informações
- `email6.eml` - Faltando email (deve processar com sucesso)
- `email8.eml` - Faltando email e telefone (deve falhar)

## 🛠️ Comandos Úteis

### Acessar o console Rails
```bash
docker-compose run web bundle exec rails console
```

### Acessar o banco de dados
```bash
docker-compose run db psql -U postgres -d email_processor_development
```

### Ver logs do Sidekiq
```bash
docker-compose logs -f sidekiq
```

### Resetar o banco de dados
```bash
docker-compose run web bundle exec rails db:reset
```

## 📝 Regras de Negócio

1. ✅ E-mails são processados em background via Sidekiq
2. ✅ Cada processamento gera um log (sucesso ou falha)
3. ✅ Customer só é criado se houver pelo menos email OU telefone
4. ✅ Arquivos `.eml` são armazenados para reprocessamento
5. ✅ Logs antigos são removidos periodicamente
6. ✅ Sistema suporta múltiplos parsers baseados no remetente

## 🎨 Interface Web

A interface foi desenvolvida com Bootstrap 5 e inclui:
- 📤 Área de upload de arquivos
- 👥 Listagem de customers com paginação
- 📊 Dashboard de logs com estatísticas
- 🔍 Visualização detalhada de logs e customers
- 📱 Design responsivo

## 🔒 Segurança

- Validação de tipo de arquivo (.eml apenas)
- Sanitização de dados extraídos
- Proteção CSRF habilitada
- Logs de erro não expõem informações sensíveis

## 📈 Monitoramento

- Sidekiq Web UI disponível em `/sidekiq`
- Logs estruturados no banco de dados
- Estatísticas de processamento na interface

## 🚦 CI/CD

O projeto inclui GitHub Actions configurado para:
- ✅ Executar testes automaticamente
- ✅ Verificar cobertura de código
- ✅ Validar build do Docker

## 📄 Licença

Este projeto foi desenvolvido como teste técnico.

## 👨‍💻 Autor

Desenvolvido como parte do processo seletivo para Desenvolvedor Ruby on Rails (Pleno).

---

## 🎥 Vídeo Explicativo

[Link para o vídeo demonstrativo será adicionado aqui]

O vídeo demonstra:
- Uso completo do sistema
- Upload e processamento de e-mails
- Visualização de customers e logs
- Explicação da arquitetura de código
- Decisões técnicas tomadas
