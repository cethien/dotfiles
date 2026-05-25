#!/usr/bin/env bash

if [ $(((RANDOM % 100) + 1)) -gt 10 ]; then
  echo ""
  exit 0
fi

quotes=(
  "you tried your best and you failed miserably. The lesson is, never try."
  "success is just failure that hasn't happened yet."
  "The only thing all of your failures have in common is you."
  "You are unique. Just like everyone else"
  "If life doesn’t break you today, don’t worry. It will try again tomorrow"
  "People who say they’ll give 110% don’t understand how percentages work"
  "A thousand-mile journey starts with one step. Then again, so does falling in a ditch and breaking your neck"
  "If you never try anything new, you’ll miss out on many of life’s great disappointments"
  "Today is the first day of the rest of your life. But so was yesterday, and look how that turned out"
  "Just because you are unique doesn't mean you are useful"
)

echo "${quotes[$((RANDOM % ${#quotes[@]}))]}"
