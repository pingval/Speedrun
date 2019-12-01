## Pre New Game Stepcount Manipulation

- [ODS Sheet](./psff8rta-stepid-manip-en.zip)
  - idx = 0: 23 enconters, 11 walking stepIDs. General strat without manip.
  - idx = 146: 19 enconters, 17 walking stepIDs. 17 encounters in manip. Luzbel's 8:19:13s strat. Tight.
  - idx = 4626: 19 enconters, 17 walking stepIDs. 495 encounters in manip. Loose than the above one.
  - idx = 40969: 18 enconters, 25 walking stepIDs. crazy **4340 encounters** in manip.
  - idx = 38213: 35 enconters, 0 walking stepIDs. Just a joke.
  - Information for making a savegame for manip.
- [Search Script (Ruby)](./psff8_stepid_manip_en.rb)
  - About all 65536 StepID states, search the least encounter count until learning Enc-None with practical walking and its way.
  - Usage: `psff8_stepid_manip_en.rb ENCOUNTER_COUNT_LIMIT WALKING_COUNT_LIMIT TARGET_DISTANCE`
  - [Output of "psff8_stepid_manip_en.rb 40 20 830"](./psff8_stepid_manip_40_20_830.zip) **100 MB over**
  - [Output of "psff8_stepid_manip_en.rb 40 30 830"](./psff8_stepid_manip_40_30_830.zip) **100 MB over**
    - allow walking 10 more stepIDs than the above one.

### References

- [darkwasabi's post on SDA Forum]( https://forum.speeddemosarchive.com/post/final_fantasy_viii_improving_on_old_847_run725.html#final_fantasy_viii_improving_on_old_847_run725)
- [Stepcounter guide by OnychuOnychu - Guides - Final Fantasy VIII - speedrun.com](https://www.speedrun.com/ff8/guide/ud8pg)
- [Final Fantasy VIII - Forum - Rule about Pre New Game manipulationspeedrun.com](https://www.speedrun.com/ff8/thread/nci3o)
- [Final Fantasy VIII - New Stepcount Tutorial - YouTube](https://www.youtube.com/watch?v=9JSVOUJHY6g)
