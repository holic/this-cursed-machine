import type { Command } from "@components/Main/Terminal/types";
import { COMMAND, OutputType } from "@components/Main/Terminal/types";
import { connect as sendConnect } from "@modules/action";
import { loadingLine, loadingSpinner, writeToTerminal } from "@components/Main/Terminal/functions/writeToTerminal";
import { waitForCompletion, waitForTransaction } from "@modules/action/actionSequencer/utils"
import { playSound } from "@modules/sound";
import { PORT_INDEX } from "@modules/state/base/enums";

async function execute(sourceMachine: string, targetMachine: string, portIndex: PORT_INDEX) {
    try {
        writeToTerminal(OutputType.NORMAL, "Allocating pipe...")
        // ...
        const action = sendConnect(sourceMachine, targetMachine, portIndex)
        // ...
        await waitForTransaction(action, loadingSpinner)
        // ...
        writeToTerminal(OutputType.NORMAL, "Connection in progress...")
        await waitForCompletion(action, loadingLine)
        playSound("tcm", "TRX_yes")
        await writeToTerminal(OutputType.SUCCESS, "Done")
        // ...
        return;
    } catch (error) {
        console.error(error)
        playSound("tcm", "TRX_no")
        await writeToTerminal(OutputType.ERROR, "Command failed")
        return
    }
}

export const connect: Command<[sourceMachine: string, targetMachine: string, portIndex: PORT_INDEX]> = {
    id: COMMAND.CONNECT,
    public: true,
    name: "connect",
    alias: "c",
    description: "Connect machines",
    fn: execute,
}