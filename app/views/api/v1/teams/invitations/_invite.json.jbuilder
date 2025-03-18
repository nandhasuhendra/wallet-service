json.id invite.id
json.team invite.team.name
json.sender invite.sender.name
json.recipient invite.recipient.name
json.accepted_at invite.accepted_at
json.accepted invite.accepted_at.present? ? "Accepted" : "Pending"
