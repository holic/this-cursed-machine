import { MachineType } from "../../modules/state/enums";

export enum OutputType {
    ERROR,
    COMMAND,
    NORMAL,
    SUCCESS,
    HELP,
    SPECIAL
}

export enum COMMAND {
    BLINK,
    CLEAR,
    HELP,
    BUILD,
    DESTROY,
    CONNECT,
    DISCONNECT,
    INSPECT,
    RESOLVE,
    TRANSFER
}

export type Command<T extends any[] = any[]> = {
    id: COMMAND;
    public: boolean;
    name: string;
    alias: string;
    description: string;
    fn: (...args: T) => Promise<void>;
}

export type Output = {
    type: OutputType;
    text: string;
    symbol: string;
}

export type SelectOption = {
    value: string | MachineType
    label: string
}