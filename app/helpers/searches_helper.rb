module SearchesHelper
  def word_wav_url(wav_file_name)
    subdirectory = if wav_file_name =~ /^bix.*/
                     'bix'
                   elsif wav_file_name =~ /^gg.*/
                     'gg'
                   elsif wav_file_name.match(/(^[\d]+).*/)
                     wav_file_name.match(/(^[\d]+).*/)[1]
                   else
                     wav_file_name.slice(0)
                   end
    "https://media.merriam-webster.com/soundc11/#{subdirectory}/#{wav_file_name}.wav"
  end
end
