class LearnTemplate < ApplicationRecord
  belongs_to :user
  has_rich_text :content
  validates :content, length: { maximum: 2000 }

  DEFAULT_JA =  <<~"TRIX"
    <h1>意味</h1>
    <ol><li> </li></ol>
    <h1>例文</h1>
    <ol><li> </li></ol>
    <h1>類義語</h1>
    <ul><li> </li></ul>
    <h1>反意語</h1>
    <ul><li> </li></ul>
  TRIX

  DEFAULT_EN =  <<~"TRIX"
    <h1>Definition</h1>
    <ol><li> </li></ol>
    <h1>Examples</h1>
    <ol><li> </li></ol>
    <h1>Synonyms</h1>
    <ul><li> </li></ul>
    <h1>Antonyms</h1>
    <ul><li> </li></ul>
  TRIX
end
