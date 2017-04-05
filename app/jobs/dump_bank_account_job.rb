require 'google_drive'

class DumpBankAccountJob < ApplicationJob
  queue_as :default

  def perform(bank_account)
    session = GoogleDrive::Session.from_service_account_key("config/simrep-google-serviceaccount.json")
    dump_folder = session.collection_by_url(ENV['DUMP_FOLDER_URL'])
      .subcollection_by_title('Bank Accounts')
      .subcollection_by_title(bank_account.chapter.name)

    localhost = `getent hosts app | awk '{ print $1 ; exit }'`.strip
    filename = "#{bank_account.owner.name}_#{Date.current.to_formatted_s(:iso8601)}".parameterize + ".pdf"
    command = "curl 'athena:8081/convert\?auth\=arachnys-weaver\&url\=http://#{localhost}:3000/bank_accounts/#{bank_account.id}/print'"

    pdf_stream = StringIO.new(`#{command}`)
    raise AthenaConversionError if pdf_stream.length < 1000

    dump_folder.upload_from_io(pdf_stream, filename)
    bank_account.update(uploaded_at: Time.current)
  end
end
