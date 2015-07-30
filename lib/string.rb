
class String
  ACCENTS_MAPPING = {
    'E'  => [200,201,202,203],
    'e'  => [232,233,234,235],
    'A'  => [192,193,194,195,196,197],
    'a'  => [224,225,226,227,228,229,230],
    'C'  => [199],
    'c'  => [231],
    'O'  => [210,211,212,213,214,216],
    'o'  => [242,243,244,245,246,248],
    'I'  => [204,205,206,207],
    'i'  => [236,237,238,239],
    'U'  => [217,218,219,220],
    'u'  => [249,250,251,252],
    'N'  => [209],
    'n'  => [241],
    'Y'  => [221],
    'y'  => [253,255],
    'AE' => [306],
    'ae' => [346],
    'OE' => [188],
    'oe' => [189]
  }

  SHORTNAMES = {
    "endereco" => "end",
    "telefone" => "fone",
  }

  def remove_accents
    str = String.new(self)
    String::ACCENTS_MAPPING.each {|letter,accents|
      packed = accents.pack('U*')
      rxp = Regexp.new("[#{packed}]", nil)
      str.gsub!(rxp, letter)
    }
    str
  end

  def replace_spaces
    String.new(self).strip.gsub(' ', '+')
  end

  def shortname
    name = String.new(self).strip.remove_accents
    SHORTNAMES[name] || name
  end
end

