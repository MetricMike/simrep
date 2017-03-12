class DumpCharacterJob < ApplicationJob
  queue_as :default

  def perform(character)
    session = GoogleDrive::Session.from_service_account_key("config/simrep-google-serviceaccount.json")
    char_dump_folder = session.collection_by_url(ENV['DUMP_FOLDER_URL'])
      .subcollection_by_title('Characters')

    localhost = `getent hosts app | awk '{ print $1 ; exit }'`.strip
    filename = "#{character.name}_#{Date.current.to_formatted_s(:iso8601)}".parameterize + ".pdf"
    command = "curl 'athena:8081/convert\?auth\=arachnys-weaver\&url\=http://#{localhost}:3000/characters/#{character.id}/print'"

    char_stream = StringIO.new(`#{command}`)
    raise AthenaConversionError if char_stream.length < 1000

    char_dump_folder.upload_from_io(char_stream, filename)
    character.update(uploaded_at: Time.current)
  end
end
