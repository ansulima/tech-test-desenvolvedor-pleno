class EmailFile < ApplicationRecord
  validates :filename, presence: true
  validates :content, presence: true

  def size_in_kb
    (file_size / 1024.0).round(2) if file_size
  end
end
