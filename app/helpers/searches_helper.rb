module SearchesHelper
  def word_wav_url(wav_file_name)
    if wav_file_name =~ /^bix.*/
      subdirectory = 'bix'
    elsif wav_file_name =~ /^gg.*/
      subdirectory = 'gg'
    elsif wav_file_name.match(/(^[\d]+).*/)
      subdirectory = wav_file_name.match(/(^[\d]+).*/)[1]
    else
      subdirectory = wav_file_name.slice(0)
    end
    "https://media.merriam-webster.com/soundc11/#{subdirectory}/#{wav_file_name}.wav"
  end
end
