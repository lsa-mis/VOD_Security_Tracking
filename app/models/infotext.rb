# == Schema Information
#
# Table name: infotexts
#
#  id         :bigint           not null, primary key
#  location   :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Infotext < ApplicationRecord
  has_rich_text :content
end
