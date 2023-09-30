import { defineConfig } from "tinacms";
//import { postFields } from "./templates";
import slugify from "slugify";

// Your hosting provider likely exposes this as an environment variable
const branch = process.env.HEAD || process.env.VERCEL_GIT_COMMIT_REF || "master";

function pad2(x: number) {
    return x.toString().padStart(2, '0');
}

function formatDate(d: Date) {
    return `${d.getFullYear()}-${pad2(d.getMonth() + 1)}-${pad2(d.getDate())}`
}

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
      publicFolder: "",
      mediaRoot: "img"
    },
  },
  schema: {
    collections: [
      {
        label: 'Posts',
        name: 'post',
        path: '_posts',
         ui: {
          filename: {
            readonly: false,
            slugify: (values: any) => {
              // Values is an object containing all the values of the form. In this case it is {title?: string, topic?: string}
              return `${formatDate(new Date())}-${slugify(values?.title || '', {lower: true, strict: true})}`
            },
          },
        },
        fields: [
          {
            type: 'string',
            label: 'Title',
            name: 'title',
          },
          {
            type: 'datetime',
            label: 'Date',
            name: 'date',
          },
          {
            type: 'rich-text',
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
          },
          {
            name: 'image',
            type: 'image',
            label: 'Image'
          }
        ],
      }
    ],
  },
});
