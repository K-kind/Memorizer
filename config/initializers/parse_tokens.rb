class String
  def parse_tokens
    gsub(/\{it\}|\{\/it\}|\{bc\}|\{phrase\}|\{\/phrase\}|\{ldquo\}|\{rdquo\}|\{dx\}|\{\/dx\}|\*/,
      '{it}' => '<i>', '{/it}' => '\</i\>', '{bc}' => '<strong>: </strong>',
      '{phrase}' => '<strong>', '{/phrase}' => '</strong>', '{ldquo}' => '“', '{rdquo}' => '”',
      '{dx}' => '—', '{/dx}' => '', '*' => '')
      .gsub(/\{dxt\|([^\|]+)\|\|([^\}]*)\}/, '<span class=\"upcase\">\1</span> <i>\2</i>')
      .gsub(/([a-zA-Z]+):([\d]+)/, '<sup>\2</sup>\1')
      .html_safe
  end
  
  # response.bodyがstringの場合にnilを返す
  def dig(*)
  end
end
