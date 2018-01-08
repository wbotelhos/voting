RSpec.shared_context 'with_database_records' do
  let!(:category) { create :category }

  let!(:author_1) { create :author }
  let!(:author_2) { create :author }
  let!(:author_3) { create :author }

  let!(:comment_1) { create :comment }
  let!(:comment_2) { create :comment }
  let!(:comment_3) { create :comment }

  let!(:vote_1) { create :voting_vote, author: author_1, positive: 1, resource: comment_1 }
  let!(:vote_2) { create :voting_vote, author: author_2, negative: 1, resource: comment_1 }
  let!(:vote_3) { create :voting_vote, author: author_3, positive: 1, resource: comment_1 }

  let!(:vote_4) { create :voting_vote, author: author_1, negative: 1, resource: comment_2 }
  let!(:vote_5) { create :voting_vote, author: author_2, positive: 1, resource: comment_2 }
  let!(:vote_6) { create :voting_vote, author: author_3, negative: 1, resource: comment_2 }

  let!(:vote_7) { create :voting_vote, author: author_1, resource: comment_1, positive: 1, scopeable: category }
  let!(:vote_8) { create :voting_vote, author: author_2, resource: comment_1, negative: 1, scopeable: category }
end
