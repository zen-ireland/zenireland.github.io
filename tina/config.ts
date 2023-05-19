import { defineConfig } from "tinacms";
import { postFields } from "./templates";

// Your hosting provider likely exposes this as an environment variable
const branch = process.env.HEAD || process.env.VERCEL_GIT_COMMIT_REF || "master";

export default defineConfig({
  branch,
  clientId: 'b93c9438-a1c7-4af1-9690-c46b5a0f3c18', // Get this from tina.io
  token: process.env.TINA_TOKEN, // Get this from tina.io
  client: { skip: true },
  build: {
    outputFolder: "admin",
    publicFolder: "./",
  },
  media: {
    tina: {
      mediaRoot: "",
      publicFolder: "./",
    },
  },
  schema: {
    collections: [
      {
        label: 'Posts',
        name: 'post',
        path: '_posts',
        fields: [
          {
            type: 'string',
            label: 'Title',
            name: 'title',
            required: true,
          },
          {
            type: 'datetime',
            label: 'Date',
            name: 'date',
            required: true,
          },
          {
            type: 'string',
            label: 'Post Body',
            name: 'body',
            isBody: true,
          },
          {
            label: 'Categories',
            name: 'categories',
            type: 'string',
            list: true,
            options: [
              {
                value: 'dublin',
                label: 'Dublin',
              },
              {
                value: 'galway',
                label: 'Galway',
              },
              {
                value: 'sesshin',
                label: 'Sesshin',
              },
              {
                value: 'limerick',
                label: 'Limerick',
              },
            ],
          }
        ],
      }
    ],
  },
});
