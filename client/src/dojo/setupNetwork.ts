import { Query, RPCProvider } from '@dojoengine/core';
import { GraphQLClient } from 'graphql-request';
import { Account, AllowArray, Call } from 'starknet';
import { getSdk } from '../generated/graphql';
import { defineContractComponents } from './contractComponents';
import manifest from './manifest.json';
import { world } from './world';
