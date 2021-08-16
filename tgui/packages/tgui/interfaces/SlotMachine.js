import { useBackend } from "../backend";
import { Button, LabeledList, Box, AnimatedNumber, Section } from "../components";
import { Window } from "../layouts";

export const SlotMachine = (props, context) => {
  const { act, data } = useBackend(context);
  if (data.money === null) {
    return (
      <Window>
        <Window.Content>
          <Section>
            <Box>
              Не удалось отсканировать вашу карту или не удалось найти учетную запись!
            </Box>
            <Box>
              Пожалуйста, наденьте или держите свою ID-карту и повторите попытку.
            </Box>
          </Section>
        </Window.Content>
      </Window>
    );
  } else {
    let playerText;
    if (data.plays === 1) {
      playerText = data.plays + " игрок испытал свою удачу сегодня!";
    } else {
      playerText = data.plays + " игрока сегодня испытали свою удачу!";
    }
    return (
      <Window>
        <Window.Content>
          <Section>
            <Box lineHeight={2}>
              {playerText}
            </Box>
            <LabeledList>
              <LabeledList.Item label="Оставшиеся кредиты">
                <AnimatedNumber
                  value={data.money}
                />
              </LabeledList.Item>
              <LabeledList.Item label="50 кредитов для вращения">
                <Button
                  icon="coins"
                  disabled={data.working}
                  content={data.working ? "Вращение..." : "Крутить"}
                  onClick={() => act("spin")} />
              </LabeledList.Item>
            </LabeledList>
            <Box bold lineHeight={2} color={data.resultlvl}>
              {data.result}
            </Box>
          </Section>
        </Window.Content>
      </Window>
    );
  }
};
