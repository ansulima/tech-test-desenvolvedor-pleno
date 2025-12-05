
class EmailProcessorService
  PARSER_MAPPING = {
    'loja@fornecedorA.com' => EmailParsers::FornecedorAParser,
    'contato@parceiroB.com' => EmailParsers::ParceiroBParser
  }.freeze

  attr_reader :email_content, :filename

  def initialize(email_content, filename)
    @email_content = email_content
    @filename = filename
  end

  def process
    parser = select_parser
    
    unless parser
      log_failure("No parser found for sender: #{sender}", nil)
      return { success: false, error: "Unknown sender" }
    end

    extracted_data = parser.extract_customer_info

    unless parser.valid_contact_info?(extracted_data)
      log_failure("No valid contact information found", extracted_data)
      return { success: false, error: "Missing contact information" }
    end

    customer = create_customer(extracted_data)
    
    if customer.persisted?
      log_success(extracted_data, customer)
      { success: true, customer: customer }
    else
      log_failure("Failed to create customer: #{customer.errors.full_messages.join(', ')}", extracted_data)
      { success: false, error: customer.errors.full_messages.join(', ') }
    end
  rescue StandardError => e
    log_failure("Exception: #{e.message}", nil)
    { success: false, error: e.message }
  end

  private

  def select_parser
    parser_class = PARSER_MAPPING[sender]
    parser_class&.new(email_content)
  end

  def sender
    @sender ||= Mail.read_from_string(email_content).from&.first
  end

  def create_customer(data)
    Customer.create(
      name: data[:name],
      email: data[:email],
      phone: data[:phone],
      product_code: data[:product_code],
      subject: data[:subject]
    )
  end

  def log_success(extracted_data, customer)
    ProcessingLog.create!(
      filename: filename,
      sender: sender,
      status: 'success',
      extracted_data: extracted_data.to_json,
      customer: customer,
      processed_at: Time.current
    )
  end

  def log_failure(error_message, extracted_data)
    ProcessingLog.create!(
      filename: filename,
      sender: sender,
      status: 'failed',
      extracted_data: extracted_data&.to_json,
      error_message: error_message,
      processed_at: Time.current
    )
  end
end
