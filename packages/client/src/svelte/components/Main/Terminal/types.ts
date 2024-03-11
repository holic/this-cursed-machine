import { MACHINE_TYPE } from "@modules/state/base/enums";

export enum TerminalType {
    FULL,
    SPAWN,
    NAMING
}

export enum DIRECTION {
    OUTGOING,
    INCOMING
}

export enum OutputType {
    ERROR,
    COMMAND,
    NORMAL,
    SUCCESS,
    HELP,
    SPECIAL,
    SPECIALINV,
    INFO
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
    TRANSFER,
    MAP,
    ORDER,
    SKIP,
    START,
    COMPLETE,
    FAIL,
    ATTACH_DEPOT,
    DETACH_DEPOT,
    CLEAR_DEPOT,
    FILL,
    ACCEPT,
    BUY,
    GRADUATE
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
    label: string
    value: string | MACHINE_TYPE | null
}